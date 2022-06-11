module AdminsAuth
  extend ActiveSupport::Concern
  ADMINS_AUTH_DEBUG_MODE = false

  # see: https://qiita.com/masuidrive/items/f2ae316dc8e98b4ff82a
  # https://qiita.com/k5trismegistus/items/3e7339a602f46e9f9087
  # https://api.rubyonrails.org/v5.2.3/classes/ActiveSupport/Callbacks.html

  included do
    [
      :admin_require_login,
      :admin_login,
      :admin_logout,
    ].each do |method|
      before_callback_method = "before_#{method}".to_sym
      after_callback_method = "after_#{method}".to_sym
      origin1 = "#{method}_without_hook".to_sym
      alias_method origin1, method
      define_method(method) do |*args, &block|
        send(before_callback_method) if respond_to?(before_callback_method, true)
        result = send(origin1, *args, &block)
        send(after_callback_method) if respond_to?(after_callback_method, true)
        result
      end
    end
  end

  # TODO: 
  # module BruteForceProtection
  #   CONFIG_UNLOCK_TOKEN_MAILER = AdminMailer
  #   def login_lock!
  #   end
  #   def login_locked?
  #   end
  #   def login_unlocked?
  #   end
  #   def send_unlock_token_email!
  #   end
  # end

  # It is necessary to import the following migration
  # ```
  # class AddActivityLoggingToAdmins < ActiveRecord::Migration[6.0]
  #   def change
  #     add_column :admins, :last_login_at, :datetime
  #     add_column :admins, :last_logout_at, :datetime
  #     add_column :admins, :last_activity_at, :datetime
  #     add_column :admins, :last_login_from_ip_address, :string
  #     add_index :admins, [:last_logout_at, :last_activity_at]
  #   end
  # end
  # ```

  module ActivityLogging
    private
      # Override.
      def after_admin_require_login
        super
        return unless admin_logged_in?
        admin_current_user.update_attribute(:last_activity_at, Time.current)
        admin_current_user.update_attribute(:last_login_from_ip_address, request.remote_ip)
      end

      def after_admin_login
        super
        return unless admin_logged_in?
        admin_current_user.update_attribute(:last_login_at, Time.current)
      end

      def before_admin_logout
        super
        return unless admin_logged_in?
        admin_current_user.update_attribute(:last_logout_at, Time.current)
      end
  end
  prepend ActivityLogging

  module SessionTimeout
    CONFIG_SESSION_TIMEOUT = 3.days
    CONFIG_SESSION_TIMEOUT_FROM_LAST_ACTION = false

    ADMIN_LOGIN_TIME = :admin_login_time
    ADMIN_LAST_LOGIN_TIME = :admin_last_login_time

    private
      # Registers last login to be used as the timeout starting point.
      # Runs as a hook after a successful login.
      def session_timeout_register_login_time!
        session[ADMIN_LOGIN_TIME] = session[ADMIN_LAST_LOGIN_TIME] = Time.now.in_time_zone
      end

      def session_timeout_update_login_time!
        current_time = Time.now.in_time_zone
        session[ADMIN_LOGIN_TIME] = current_time if session[ADMIN_LOGIN_TIME].blank?
        session[ADMIN_LAST_LOGIN_TIME] = current_time
      end

      def session_timeout_login_time_expired?
        session_to_use = CONFIG_SESSION_TIMEOUT_FROM_LAST_ACTION ? session[ADMIN_LAST_LOGIN_TIME] : session[ADMIN_LOGIN_TIME]
        session_to_use && session_timeout_session_expired?(session_to_use.to_time)
      end

      def session_timeout_session_expired?(time)
        Time.now.in_time_zone - time > CONFIG_SESSION_TIMEOUT
      end

      # Override.
      def before_admin_require_login
        super
        if session_timeout_login_time_expired?
          admin_logout
          admin_reset_session!
        end
      end

      # Override.
      def after_admin_require_login
        super
        unless session_timeout_login_time_expired?
          session_timeout_update_login_time!
        end
      end
      
      # Override.
      def after_admin_login
        super
        session_timeout_register_login_time!
      end
  end
  prepend SessionTimeout



  # It is necessary to import the following migration
  # ```
  # class AddRememberDigestToAdmins < ActiveRecord::Migration[6.0]
  #   def change
  #     add_column :admins, :remember_digest, :string
  #     add_column :admins, :remember_expires_at, :datetime, default: nil
  #   end
  # end
  # ```
  module RememberMe
    CONFIG_REMEMBER_ME_PERIOD = 7.days.from_now.utc

    ADMIN_REMEMBER_ME_USER_ID = :admin_remember_me_user_id
    ADMIN_REMEMBER_ME_TOKEN = :admin_remember_me_token

    def admin_remember_me!
      token, digest = admin_generate_token
      admin_set_remember_me_cookie!(@admin_current_user.id, token, expires = CONFIG_REMEMBER_ME_PERIOD)
      @admin_current_user.update!(remember_digest: digest)
    end

    def admin_forget_me!
      admin_destroy_remember_me_cookie!
    end

    # Override.
    # generate session[ADMIN_CURRENT_USER]
    def admin_login(user_name_or_email, password, **option)
      if @admin_current_user = admin_user_authenticate_by_user_name(user_name_or_email, password) || admin_user_authenticate_by_email(user_name_or_email, password)
        session[ADMIN_CURRENT_USER] = @admin_current_user.id.to_s
        admin_remember_me! if option[:remember] && option[:remember] == "1"
        @admin_current_user
      else
        false
      end
    end

    def admin_logout
      session.delete(ADMIN_CURRENT_USER)
      admin_destroy_remember_me_cookie!
      @admin_current_user = nil
    end

    # require session[ADMIN_CURRENT_USER]
    def admin_current_user
      @admin_current_user ||= admin_login_from_session || admin_login_from_remember_me_cookie
    end

    protected
      def admin_login_from_remember_me_cookie
        user_id = cookies.signed[ADMIN_REMEMBER_ME_USER_ID]
        remember_token = cookies.encrypted[ADMIN_REMEMBER_ME_TOKEN]
        if user_id.present?
          user ||= Admin.find_by(id: user_id)
          if user && user.remember_digest && BCrypt::Password.new(user.remember_digest).is_password?(remember_token)
            admin_reset_session!
            @admin_current_user = user
          end
        end
      end

      def admin_set_remember_me_cookie!(id, token, expires = 20.years.from_now.utc)
        cookies.signed[ADMIN_REMEMBER_ME_USER_ID] = {
          value: id,
          expires: expires,
          httponly: true,
          domain: nil
        }
        cookies.encrypted[ADMIN_REMEMBER_ME_TOKEN] = {
          value: token,
          expires: expires,
          httponly: true,
          domain: nil
        }
      end

      def admin_destroy_remember_me_cookie!
        cookies.delete ADMIN_REMEMBER_ME_USER_ID
        cookies.delete ADMIN_REMEMBER_ME_TOKEN
      end
      
      def admin_generate_token
        token = SecureRandom.urlsafe_base64
        digest = admin_digest_token(token)
        [ token, digest ]
      end

    private
      def admin_digest_token(token)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(token, cost: cost)
      end
  end
  prepend RememberMe

  ADMIN_CURRENT_USER = :admin_user_id

  # check session[ADMIN_CURRENT_USER]
  def admin_require_login
    return if admin_logged_in?
    if request.get? && !request.xhr? && !request.format.json?
      session[:admin_return_to_url] = request.url
    end
    admin_not_authenticated
  end

  # generate session[ADMIN_CURRENT_USER]
  def admin_login(user_name_or_email, password, **option)
    if @admin_current_user = admin_user_authenticate_by_user_name(user_name_or_email, password) || admin_user_authenticate_by_email(user_name_or_email, password)
      session[ADMIN_CURRENT_USER] = @admin_current_user.id.to_s
      @admin_current_user
    else
      false
    end
  end

  # require session[ADMIN_CURRENT_USER]
  def admin_logout
    session.delete(ADMIN_CURRENT_USER)
    @admin_current_user = nil
  end

  # require session[ADMIN_CURRENT_USER]
  def admin_logged_in?
    !!admin_current_user
  end

  # require session[ADMIN_CURRENT_USER]
  def admin_current_user
    @admin_current_user ||= admin_login_from_session
  end

  def admin_valid_password(admin, password)
    admin.authenticate(password)
  end

  # used when a user tries to access a page while logged out, is asked to login,
  # and we want to return him back to the page he originally wanted.
  def admin_redirect_back_or_to(url, flash_hash = {})
    redirect_to(session[:admin_return_to_url] || url, flash: flash_hash)
    session[:admin_return_to_url] = nil
  end

  protected
    
    def admin_not_authenticated
      redirect_to admins_accounts_path
    end

    # protect from session fixation attacks
    def admin_reset_session!
      old_session = session.dup.to_hash
      reset_session
      p old_session if ADMINS_AUTH_DEBUG_MODE
      old_session.each_pair do |k, v|
        session[k.to_sym] = v
      end
    end

    def admin_user_authenticate_by_email(email, password)
      return unless Admin.has_attribute?(:email)
      user = Admin.find_by(email: email.downcase)
      if user && user.authenticate(password)
        user
      else
        nil
      end
    end

    def admin_user_authenticate_by_user_name(user_name, password)
      return unless Admin.has_attribute?(:user_name)
      user = Admin.find_by(user_name: user_name.downcase)
      if user && user.authenticate(password)
        user
      else
        nil
      end
    end

    def admin_login_from_session
      if session[ADMIN_CURRENT_USER]
        @admin_current_user ||= Admin.find_by(id: session[ADMIN_CURRENT_USER])
      end
    end

  private
    def before_admin_require_login
      p admin_login_from_remember_me_cookie if ADMINS_AUTH_DEBUG_MODE
      puts 'before_admin_require_login' if ADMINS_AUTH_DEBUG_MODE
    end

    def after_admin_require_login
      puts 'after_admin_require_login' if ADMINS_AUTH_DEBUG_MODE
    end

    def before_admin_login
      puts 'before_admin_login' if ADMINS_AUTH_DEBUG_MODE
    end

    def after_admin_login
      admin_reset_session!
      puts 'after_admin_login' if ADMINS_AUTH_DEBUG_MODE
    end

    def before_admin_logout
      puts 'before_admin_logout' if ADMINS_AUTH_DEBUG_MODE
    end

    def after_admin_logout
      admin_reset_session!
      puts 'after_admin_logout' if ADMINS_AUTH_DEBUG_MODE
    end
end

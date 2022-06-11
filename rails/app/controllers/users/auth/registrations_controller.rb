class Users::Auth::RegistrationsController < Users::BaseController
  layout 'auth_basic_for_user'
  skip_before_action :require_login

  def new
    if logged_in?
      redirect_back_or_to(root_path) 
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '確認メールを送信しました。受信ボックスを確認して、アカウントを有効化してください'
      redirect_to thanks_create_users_auth_registrations_path
    else
      render :new
    end
  end

  def thanks_create
  end

  def activate
    token = params[:registration_id]
    @user = User.load_from_activation_token(token)
    @user.activate!
    auto_login(@user)
    redirect_to thanks_activate_users_auth_registrations_path
  end

  def thanks_activate
  end
  
  private
    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
      )
    end
end

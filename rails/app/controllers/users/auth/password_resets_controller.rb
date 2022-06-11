class Users::Auth::PasswordResetsController < Users::BaseController
  layout 'auth_basic_for_user'
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(user_create_params[:email])
    if @user
      @user.deliver_reset_password_instructions!
    end
    redirect_to thanks_create_users_auth_password_resets_path
  end

  def thanks_create
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    @user.attributes = user_update_params
    if @user.save
      redirect_to thanks_update_users_auth_password_resets_path
    else
      render :edit
    end
  end

  def thanks_update
  end

  private
    def user_create_params
      params.require(:user).permit(
        :email,
      )
    end

    def user_update_params
      params.require(:user).permit(
        :password,
        :password_confirmation
      )
    end
end

class Users::Auth::PasswordChangesController < Users::BaseController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if params[:password].blank? || params[:password_confirmation].blank?
      flash[:alert] = 'パスワードを入力してください'
      return redirect_to edit_users_settings_path
    end

    if params[:password] != params[:password_confirmation]
      flash[:alert] = 'パスワードが一致しません'
      return redirect_to edit_users_settings_path
    end

    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      redirect_to edit_users_settings_path, notice: 'パスワードを更新しました'
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :password,
        :password_confirmation,
      )
    end
end

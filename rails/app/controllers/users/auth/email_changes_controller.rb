class Users::Auth::EmailChangesController < Users::BaseController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.email = params[:email]

    if @user.save
      redirect_to edit_users_settings_path, notice: 'メールアドレスを更新しました'
    else
      render :edit
    end
  end
end

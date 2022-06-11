class Admins::Auth::PasswordChangesController < Admins::BaseController
  def edit
    @admin = admin_current_user
  end

  def update
    @admin = admin_current_user

    unless @admin.authenticate(params[:admin][:password_now])
      flash.now[:alert] = '現在のパスワードが違います'
      return render :edit
    end

    @admin.attributes = password_params

    if @admin.save
      redirect_to edit_admins_auth_password_changes_path, notice: '更新しました'
    else
      flash[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  private
    def password_params
      params.require(:admin).permit(
        :password,
        :password_confirmation,
      )
    end
end

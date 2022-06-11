class Users::Auth::WithdrawalsController < Users::BaseController
  # 退会処理
  def destroy
    @user = current_user
    logout
    @user.destroy
    redirect_to root_path
  end
end

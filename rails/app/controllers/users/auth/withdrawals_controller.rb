class Users::Auth::WithdrawalsController < Users::BaseController
  # ιδΌε¦η
  def destroy
    @user = current_user
    logout
    @user.destroy
    redirect_to root_path
  end
end

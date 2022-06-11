class Admins::Auth::SessionsController < Admins::BaseController
  layout "admins/layouts/not_loggedin"
  skip_before_action :admin_require_login, only: [:new, :create]

  def new
    if admin_logged_in?
      redirect_to admins_root_path, notice: 'すでにログインしています'
    end
  end

  def create
    @admin_user = Admin.actives.find_by(email: params[:email].downcase)

    if @admin_user && @admin_user.status_pending?
      flash[:alert] = 'アカウントは停止されています'
      return render :new
    end

    if @admin_user = admin_login(params[:email], params[:password], remember: params[:remember])
      flash[:notice] = 'ログインしました'
      redirect_to admins_root_path
    else
      flash[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    admin_logout
    redirect_to admins_login_path
  end
end

class Users::Auth::SessionsController < Users::BaseController
  layout 'auth_basic_for_user'
  skip_before_action :require_login, only: [:new, :create]

  def new
    if logged_in?
      flash[:notice] = 'すでにログインしています'
      redirect_to(root_path) 
    end
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember] == '0' ? nil : 1)
      auto_login(@user)
      flash[:notice] = 'ログインしました'
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to users_me_path
      end
    else
      flash[:alert] = 'メールアドレスかパスワードが間違っています'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end

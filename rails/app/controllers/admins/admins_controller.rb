class Admins::AdminsController < Admins::BaseController
  def index
    @admin = Admin.new
    @admins = Admin.all
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    redirect_path = params[:redirect_to] || admins_admins_path
    if @admin.save
      redirect_to redirect_path, notice: '登録しました'
    else
      render :new
    end
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    @admin.attributes = admin_params

    if admin_params[:password].blank? && admin_params[:password_confirmation].present?
      flash.now[:alert] = 'パスワードを入力してください'
      return render :edit
    end

    if admin_params[:password].present? && admin_params[:password_confirmation].blank?
      flash.now[:alert] = '確認用のパスワードを入力してください'
      return render :edit
    end

    redirect_path = params[:redirect_to] || admins_admins_path
    if @admin.save
      redirect_to redirect_path, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    redirect_path = params[:redirect_to] || admins_admins_path
    if @admin.destroy
      redirect_to redirect_path, notice: '削除しました'
    else
      redirect_to redirect_path, alert: '削除に失敗しました'
    end
  end
  
  private
    def admin_params
      params.require(:admin).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
      )
    end
end

class Admins::AppConfigsController < Admins::BaseController
  def index
    @app_configs = AppConfig.all
  end

  def edit
    @app_config = AppConfig.find(params[:id])
  end

  def update
    @app_config = AppConfig.find(params[:id])
    @app_config.attributes = app_config_params
    if @app_config.save
      redirect_to admins_app_configs_path, notice: '設定を変更しました'
    else
      render :edit
    end
  end

  private
    def app_config_params
      params.require(:app_config).permit(
        :value
      )
    end
end

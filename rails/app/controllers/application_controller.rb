class ApplicationController < ActionController::Base
  before_action :set_cache_buster

  protected
    # Called by sorcery
    def not_authenticated
      respond_to do |format|
        format.html do
          flash[:notice] = 'サービスを利用するには、ログインが必要です'
          redirect_to login_path(redirect_to: request.fullpath)
        end
        format.json { render status: 401, json: { status: 401, message: 'Unauthorized', location: login_url } }
      end
    end

    # Called by sorcery
    def logged_in?
      current_user && current_user.undiscarded? && current_user.status_active?
    end

  private
    # Called by sorcery
    def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end

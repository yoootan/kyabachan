class Admins::BaseController < ApplicationController
  include AdminsAuth
  helper AdminsAuth
  layout 'admins/layouts/base'
  before_action :admin_require_login

  # override lib module
  # see: AdminsAuth::admin_not_authenticated
  def admin_not_authenticated
    respond_to do |format|
      message = 'ダッシュボードを見るにはログインが必要です'
      format.html do
        redirect_to admins_login_path, alert: message
      end
      format.json do
        render status: 401, json: { status: 401, message: message, location: admins_login_url }
      end
    end
  end

  # override lib module
  # see: AdminsAuth::admin_logged_in?
  def admin_logged_in?
    admin_current_user && admin_current_user.undiscarded?
  end
end

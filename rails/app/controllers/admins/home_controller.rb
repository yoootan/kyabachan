class Admins::HomeController < Admins::BaseController
  def index
    @user_count = User.count
  end
end

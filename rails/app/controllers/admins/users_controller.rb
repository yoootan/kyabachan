class Admins::UsersController < Admins::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @quiz_outcomes = @user.quiz_outcomes.order(created_at: :desc)
  end
end

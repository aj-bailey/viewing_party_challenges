class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "#{user.email} created"
      redirect_to dashboard_path
    else
      flash[:notice] = "Unable to create new user - #{user.errors.full_messages}"
      redirect_to register_path
    end
  end

  def show
    @user = User.find(session[:user_id])
    @user_viewing_parties = @user.viewing_parties
    @movie_facade = MovieFacade.new
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def require_user
      unless current_user
        flash[:notice] = "You must be logged in to access dashboard"
        redirect_to root_path
      end
    end
end
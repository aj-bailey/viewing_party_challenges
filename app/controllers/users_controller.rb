class UsersController < ApplicationController
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
    if current_user
      @user = User.find(session[:user_id])
      @user_viewing_parties = @user.viewing_parties
      @movie_facade = MovieFacade.new
    else
      flash[:notice] = "You must be logged in to access dashboard"
      redirect_to root_path
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
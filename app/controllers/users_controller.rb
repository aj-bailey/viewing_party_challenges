class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "#{user.email} created"
      redirect_to user_path(user)
    else
      flash[:notice] = "Unable to create new user - #{user.errors.full_messages}"
      redirect_to register_path
    end
  end

  def show
    @user = User.find(params[:id])
    @user_viewing_parties = @user.viewing_parties
    @movie_facade = MovieFacade.new
  end

  def login_form; end

  def login_user
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.email}"
      redirect_to user_path(user)
    else
      flash.now[:error] = "Sorry, your credentials are bad"
      render :login_form, status: 400
    end
  end

  def logout_user
    reset_session
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
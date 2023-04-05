class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.email}"
      redirect_to dashboard_path
    else
      flash.now[:error] = "Sorry, your credentials are bad"
      render :new, status: 400
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
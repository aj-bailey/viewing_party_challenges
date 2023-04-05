class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      redirect_session(user)
    else
      flash.now[:error] = "Sorry, your credentials are bad"
      render :new, status: 400
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

    def redirect_session(user)
      session[:user_id] = user.id

      return admin_session(user) if user.admin?
      default_session(user)
    end

    def default_session(user)
      flash[:success] = "Welcome, #{user.email}"
      redirect_to dashboard_path
    end

    def admin_session(user)
      flash[:success] = "Admin: Welcome, #{user.email}"
      redirect_to admin_dashboard_path
    end
end
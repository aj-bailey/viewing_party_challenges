class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_admin
    unless current_admin?
      flash[:notice] = "Unauthorized attempt!"
      redirect_to root_path
    end
  end

  def current_admin?
    current_user && current_user.admin?
  end
end

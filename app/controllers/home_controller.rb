class HomeController < ApplicationController
  def index
    @users = User.default_users
  end
end
class Admin::DashboardController < ApplicationController
  def index
    @default_users = User.default_users
  end
end
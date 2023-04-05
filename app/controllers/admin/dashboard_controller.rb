class Admin::DashboardController < ApplicationController
  before_action :require_admin, only: :index

  def index
    @default_users = User.default_users
  end
end
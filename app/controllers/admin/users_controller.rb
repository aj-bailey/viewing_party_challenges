class Admin::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_viewing_parties = @user.viewing_parties
    @movie_facade = MovieFacade.new
  end
end
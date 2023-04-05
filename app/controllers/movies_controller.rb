# frozen_string_literal: true.

class MoviesController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @movie_facade = MovieFacade.new(params)
  end

  def show
    @user = User.find(session[:user_id])
    @movie_facade = MovieFacade.new(params)
  end
end

class ViewingPartiesController < ApplicationController
  def new
    if current_user
      @user = User.find(params[:user_id])
      @users = User.all
      @viewing_party = ViewingParty.new
      @movie_facade = MovieFacade.new(params)
    else
      flash[:notice] = "You must be logged in to create a viewing party"
      redirect_to user_movie_path(params[:user_id], params[:movie_id])
    end
  end

  def create
    viewing_party = ViewingParty.new(viewing_party_params)

    if viewing_party.save
      flash[:notice] = "Viewing party created"

      create_viewing_party_users(params[:users], viewing_party.id, params[:user_id])

      redirect_to dashboard_path

    else
      flash[:notice] = "Unable to create viewing party - #{viewing_party.errors.full_messages}"
      redirect_to new_user_movie_viewing_party_path(params[:user_id], params[:movie_id])
    end
  end

  private

  def viewing_party_params
    params.permit(:duration_minutes, :party_date, :party_time, :movie_id, :host_id)
  end

  def create_viewing_party_users(users, viewing_party_id, host_id)
    ViewingPartyUser.create!(user_id: host_id, viewing_party_id: viewing_party_id)

    users.reject { |user, checkbox| checkbox == "0"}.each do |user|
      ViewingPartyUser.create!(user_id: user[0].to_i, viewing_party_id: viewing_party_id)
    end
  end
end

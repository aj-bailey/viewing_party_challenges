require "rails_helper"

RSpec.describe "User Discover Index Page" do
  describe 'As a user' do
    describe "When I visit the '/users/:id/discover' path, where :id, is the id of a valid user" do
      before(:each) do
        @user = User.create!(name: "Adam", email: "adam@gmail.com", password: "test123", password_confirmation: "test123")
        
        visit login_path
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_on "Log In"
        
        visit discover_index_path
      end

      it "has a button to discover top rated movies which directs me to '/users/:id/discover' page" do
        expect(page).to have_button("Find Top Rated Movies")

        VCR.use_cassette("top_rated_movies", serialize_with: :json) do
          click_button "Find Top Rated Movies"
        end

        expect(current_path).to eq(user_movies_path(@user))
      end

      it "can search by keyword(s) for movie titles" do
        expect(page).to have_field(:q)
        expect(page).to have_button("Find Movies")
        
        fill_in :q, with: "Fight Club"

        VCR.use_cassette("fight_club_search", serialize_with: :json) do
          click_button "Find Movies"
        end

        expect(current_path).to eq(user_movies_path(@user))
      end
    end
  end
end
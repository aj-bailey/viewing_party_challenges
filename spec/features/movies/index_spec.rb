require "rails_helper"

RSpec.describe "Movies Index Page" do
  describe "when I visit the movies results page" do
    before(:each) do
      @james = User.create!(name: "James", email: "james@email.com", password: "test123", password_confirmation: "test123")

      visit user_discover_index_path(@james)
    end

    context "Top Movies" do
      before(:each) do
        VCR.use_cassette("top_rated_movies", serialize_with: :json) do
          click_button "Find Top Rated Movies"
        end
      end
      
      it "should have a 'Discover Movies' button that takes you back to '/users/:id/discover' page" do
        expect(page).to have_button("Discover Movies")
        
        click_button "Discover Movies"
        
        expect(current_path).to eq(user_discover_index_path(@james))
      end
      
      it "should include 'top+rated' in query params" do
        expect(current_url).to eq("http://www.example.com/users/#{@james.id}/movies?q=top+rated")
      end

      it 'should return 200 status code' do
        expect(page.status_code).to eq(200)
      end
      
      it "should return the top movies results" do
        within("#movie_titles") {
          expect(page).to have_css("p", count: 20 )
          expect(page).to have_link("The Godfather")
        }
      end
    end  

    context "Search button" do
      before(:each) do
        fill_in :q, with: "Fight Club"

        VCR.use_cassette("fight_club_search", serialize_with: :json) do
          click_button "Find Movies"
        end
      end
      
      it "should include 'top+rated' in query params" do
        expect(current_url).to eq("http://www.example.com/users/#{@james.id}/movies?q=Fight+Club&commit=Find+Movies")
      end

      it 'should return 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "should return the first twenty movie results for a given search string with movie titles linking to their movie show page" do
        within("#movie_titles") {
          expect(page).to have_css("p", count: 20 )
          expect(page).to have_link("Fight Club")
        }
      end
    end
  end
end
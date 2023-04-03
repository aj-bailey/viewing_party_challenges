require "rails_helper"

RSpec.describe "movie's detail page", type: :feature do
  before(:each) do
    @adam = User.create!(name: "Adam", email: "adam@adammail.com", password: "test123", password_confirmation: "test123")
    
    VCR.use_cassette("movie_details", serialize_with: :json) do
      visit user_movie_path(@adam, 238)
    end
  end

  describe "when I visit the movie destails page" do
    it "should see a button to return to the discover page" do 
      expect(page).to have_button("Discover Movies")

      click_button("Discover Movies")

      expect(current_path).to eq(user_discover_index_path(@adam))
    end

    it "should have a button to create a viewing party" do 
      expect(page).to have_button("Create Viewing Party for The Godfather")

      VCR.use_cassette("movie_details", serialize_with: :json) do
        click_button("Create Viewing Party for The Godfather")
      end

      expect(current_path).to eq(new_user_movie_viewing_party_path(@adam, 238))
    end

      #how do better??
    it "should have movie details" do
      expect(page).to have_content("The Godfather")
      expect(page).to have_content("Vote: 8.7")
      expect(page).to have_content("Runtime: 2hr 55min")
      expect(page).to have_content("Genre: Drama, Crime")
      expect(page).to have_content("Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.")
      
      within("#cast"){
        expect(page).to have_css("li", count: 10)
      } 
      
      within("#reviews"){
        expect(page).to have_content("2 Reviews")
        expect(page).to have_css("li", count: 2)
      } 
    end
  end
end
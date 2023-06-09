require "rails_helper"

RSpec.describe "movie's detail page", type: :feature do
  describe "As a user" do
    before(:each) do
      @adam = User.create!(name: "Adam", email: "adam@adammail.com", password: "test123", password_confirmation: "test123")

      visit login_path
      fill_in :email, with: @adam.email
      fill_in :password, with: @adam.password

      click_on "Log In"
      
      visit movie_path(238)
    end

    describe "when I visit the movie details page", :vcr do
      it "should see a button to return to the discover page" do 
        expect(page).to have_button("Discover Movies")

        click_button("Discover Movies")

        expect(current_path).to eq(discover_index_path)
      end

      it "should have a button to create a viewing party" do 
        expect(page).to have_button("Create Viewing Party for The Godfather")

        click_button("Create Viewing Party for The Godfather")

        expect(current_path).to eq(new_movie_viewing_party_path(238))
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
          expect(page).to have_content("3 Reviews")
          expect(page).to have_css("li", count: 3)
        } 
      end
    end
  end

  describe "As a visitor" do 
    describe "when I visit the movie details page", :vcr do
      it "should not be able to create a viewing party when not logged in" do
        visit movie_path(238)
        
        click_button("Create Viewing Party for The Godfather")

        expect(current_path).to eq(movie_path(238))

        within("#flash_message") { expect(page).to have_content("You must be logged in to create a viewing party") }
      end
    end
  end
end
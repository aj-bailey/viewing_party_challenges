require "rails_helper"

RSpec.describe "User dashboard(show) page", type: :feature do
  before :each do
    @adam = User.create!(name: "Adam", email: "adam@aol.com", password: "test123", password_confirmation: "test123")
    @james = User.create!(name: "James", email: "james@gmail.com", password: "test123", password_confirmation: "test123")
    @mike = User.create!(name: "Mike", email: "mike@hotmail.com", password: "test123", password_confirmation: "test123")
  end

  describe " when I visit the user dashboard" do
    it " I see users name at the top of the page " do
      visit login_path
      fill_in :email, with: @adam.email
      fill_in :password, with: @adam.password

      click_on "Log In"

      visit dashboard_path
      expect(page).to have_content "Adam's Dashboard"
    end

    it " I see a button to Discover Movies" do
      visit login_path
      fill_in :email, with: @adam.email
      fill_in :password, with: @adam.password

      click_on "Log In"

      visit dashboard_path

      expect(page).to have_button "Discover Movies"

      click_button "Discover Movies"

      expect(current_path).to eq(user_discover_index_path(@adam.id))
    end

    describe "I am associated with viewing parties" do
      it "should see movie image, title, date and time, who is hosting the event and list of users with my name in bold", :vcr do
        @host_party = ViewingParty.create!(duration_minutes: 200, party_date: "2023-12-28", party_time: "09:00", host_id: @adam.id, movie_id: 550)
        ViewingPartyUser.create!(user_id: @james.id, viewing_party_id: @host_party.id)
        ViewingPartyUser.create!(user_id: @mike.id, viewing_party_id: @host_party.id)
        ViewingPartyUser.create!(user_id: @adam.id, viewing_party_id: @host_party.id)

        visit login_path
        fill_in :email, with: @adam.email
        fill_in :password, with: @adam.password

        click_on "Log In"
        
        visit dashboard_path

        within("#viewing_party-#{@host_party.id}") {
          expect(page).to have_css("img")
          expect(page).to have_content("Fight Club")
          expect(page).to have_content("Date: December 28, 2023")
          expect(page).to have_content("Time: 9:00 am")
          expect(page).to have_content("Host: Adam")
          
          within("#viewing_party_users") { 
            expect(page).to have_content("Mike")
            expect(page).to have_content("James")
          }
        }

      end      
    end
  end
end
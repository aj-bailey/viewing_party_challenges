require "rails_helper"

RSpec.describe "New Viewing Party Page" do
  describe "As a user" do
    describe "When I visit the new viewing party page (/users/:user_id/movies/:movid_id/viewing-party/new, where :user_id is a valid user's id)", :vcr do
      before(:each) do
        @james = User.create!(name: "James", email: "james@email.com", password: "test123", password_confirmation: "test123")
        @adam = User.create!(name: "Adam", email: "adam@email.com", password: "test123", password_confirmation: "test123")
        @mike = User.create!(name: "Mike", email: "mike@email.com", password: "test123", password_confirmation: "test123")
        @abdul = User.create!(name: "Abdul", email: "abdul@email.com", password: "test123", password_confirmation: "test123")
        
        visit new_user_movie_viewing_party_path(@james, 550)
      end

      it "should see a button to return to the discover page" do 
        expect(page).to have_button("Discover Movies")
  
        click_button("Discover Movies")
  
        expect(current_path).to eq(user_discover_index_path(@james))
      end

      it "should see the movie title above a form which includes Party Duration, Date, Time, (un)Checkboxes for users and 'Create a Party' button" do
        expect(page).to have_content("Create a Movie Party for Fight Club")
        
        within("#party_details") {
          expect(page).to have_content("Fight Club")
          expect(page).to have_field(:duration_minutes, with: 139)
          expect(page).to have_field(:party_date)
          expect(page).to have_field(:party_time)

          within("#invite_users") {
            within("#user-#{@adam.id}") { 
              expect(page).to have_unchecked_field("users[#{@adam.id}]")
              expect(page).to have_content("Adam (adam@email.com)")
            }

            within("#user-#{@mike.id}") {
              expect(page).to have_unchecked_field("users[#{@mike.id}]") 
              expect(page).to have_content("Mike (mike@email.com)")
            }

            within("#user-#{@abdul.id}") {
              expect(page).to have_unchecked_field("users[#{@abdul.id}]")
              expect(page).to have_content("Abdul (abdul@email.com)")
            }
          }
          expect(page).to have_button("Create Party")
        }
      end
      
      it "will redirect to the user's dashboard, /user/:id, when submitting a valid for" do
        fill_in :party_date, with: "2023-12-28"
        fill_in :party_time, with: "21:17"
        check "users[#{@abdul.id}]"

        click_button "Create Party"

        expect(current_path).to eq(user_path(@james))
      end

      it "cannot create a party with less minutes than movie runtime" do
        fill_in :party_date, with: "2023-12-28"
        fill_in :party_time, with: "21:17"
        fill_in :duration_minutes, with: 0

        click_button "Create Party"

        expect(current_path).to eq(new_user_movie_viewing_party_path(@james, 550))
        within("#flash_message") { expect(page).to have_content("Unable to create viewing party - [\"Duration minutes cannot be less than movie runtime\"]")}
      end

      it "cannot create a party with a past date" do
        fill_in :party_date, with: "2023-01-28"
        fill_in :party_time, with: "21:17"

        click_button "Create Party"

        expect(current_path).to eq(new_user_movie_viewing_party_path(@james, 550))
        within("#flash_message") { expect(page).to have_content("Unable to create viewing party - [\"Party date cannot be in the past\"]")}
      end
    end
  end
end
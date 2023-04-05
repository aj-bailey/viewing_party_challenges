require 'rails_helper'

RSpec.describe 'home page, index', type: :feature do 

  before :each do
    @adam = User.create!(name: "Adam", email: "adam@aol.com", password: "test123", password_confirmation: "test123")
    @james = User.create!(name: "James", email: "james@gmail.com", password: "test123", password_confirmation: "test123")
    @mike = User.create!(name: "Mike", email: "mike@hotmail.com", password: "test123", password_confirmation: "test123")
    visit root_path
  end

  describe "as a visitor" do
    describe "when I visit the home page" do
      it "cannot see the section of the page that lists existing users" do
        expect(page).to_not have_content("adam@aol.com")
        expect(page).to_not have_content("james@gmail.com")
        expect(page).to_not have_content("mike@hotmail.com")
      end

      it "can see a button to create a new user" do
        expect(page).to have_button("Create new user")

        click_button "Create new user"

        expect(current_path).to eq(register_path)
      end

      it "has a link to log in" do
        expect(page).to have_link("Login", href: login_path)

        click_link "Login"

        expect(current_path).to eq(login_path)
      end

      it "cannot visit /dashboard until logged in or registered to access dashboard" do
        visit dashboard_path

        expect(current_path).to eq(root_path)

        within("#flash_message") { expect(page).to have_content("You must be logged in to access dashboard") }
      end
    end
  end

  describe " as a user" do
    describe " when I visit home page" do
      it "has a list of existing users emails without links to their show page" do
        user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")
      
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit root_path

        within("#existing_users") {
          expect(page).to have_content("adam@aol.com")
          expect(page).to have_content("james@gmail.com")
          expect(page).to have_content("mike@hotmail.com")

          expect(page).to_not have_link("adam@aol.com", href: dashboard_path)
          expect(page).to_not have_link("james@gmail.com", href: dashboard_path)
          expect(page).to_not have_link("mike@hotmail.com", href: dashboard_path)
        }
      end

      it "can no longer see a link to log in or create an account when visiting landing page" do
        user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")
        
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  
        visit root_path
        
        expect(page).to_not have_link("Login")
        expect(page).to have_link("Logout")
      end
    end
  end
end
require 'rails_helper'

RSpec.describe 'home page, index', type: :feature do 

  before :each do
    @adam = User.create!(name: "Adam", email: "adam@aol.com", password: "test123", password_confirmation: "test123")
    @james = User.create!(name: "James", email: "james@gmail.com", password: "test123", password_confirmation: "test123")
    @mike = User.create!(name: "Mike", email: "mike@hotmail.com", password: "test123", password_confirmation: "test123")
    visit "/"
  end

  describe " as a user" do
    describe " when I visit home page" do
      it " I see a button to create a new user" do
        expect(page).to have_button("Create new user")

        click_button "Create new user"

        expect(current_path).to eq(register_path)
      end

      it " Has a list of existing Users which links to the users dashboard" do
        within("#existing_users"){
          expect(page).to have_link("adam@aol.com", href: user_path(@adam))
          expect(page).to have_link("james@gmail.com", href: user_path(@james))
          expect(page).to have_link("mike@hotmail.com", href: user_path(@mike))
        }
      end

      it "has a link to log in" do
        expect(page).to have_link("Login", href: login_path)

        click_link "Login"

        expect(current_path).to eq(login_path)
      end
    end
  end
end
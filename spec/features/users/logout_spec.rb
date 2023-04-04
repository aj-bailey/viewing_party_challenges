require "rails_helper"

RSpec.describe "Logging out" do
  describe "As a logged in user" do
    it "can no longer see a link to log in or create an account when visiting landing page" do
      user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit root_path
      
      expect(page).to_not have_link("Login")
      expect(page).to have_link("Logout")
    end

    it "can click logout and be taken to the landing page and with a link to log in and not out" do
      user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")

      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_on "Log In"
      click_link "Home"
      click_link "Logout"

      expect(current_path).to eq(root_path)
      expect(page).to have_link("Login")
    end
  end
end
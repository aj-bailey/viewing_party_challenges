require "rails_helper"

RSpec.describe "Login Page" do
  describe "Logging In" do
    it "can log in with valid credentials" do
      user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")

      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_on "Log In"

      expect(current_path).to eq(user_path(user))
      within("#flash_message") { expect(page).to have_content("Welcome, #{user.email}")}
    end

    it "cannot log in with invalid credentials" do
      user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")

      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: "Invalid Password"

      click_on "Log In"

      expect(current_path).to eq(login_path)
      within("#flash_message") { expect(page).to have_content("Sorry, your credentials are bad")}
    end
  end
end
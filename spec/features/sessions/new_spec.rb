require "rails_helper"

RSpec.describe "Session New" do
  describe "As a user" do
    describe "Logging In" do
      it "can log in with valid credentials" do
        user = User.create!(name: "mike", email: "mike@aol.com", password: "password123")

        visit login_path

        fill_in :email, with: user.email
        fill_in :password, with: user.password

        click_on "Log In"

        expect(current_path).to eq(dashboard_path)
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

  describe "As an admin" do
    describe "Logging in" do
      it "can log in with valid credentials" do
        admin = User.create!(name: "admin", email: "admin@admin.admin", password: "admin123", role: 1)

        visit login_path

        fill_in :email, with: admin.email
        fill_in :password, with: admin.password

        click_on "Log In"

        expect(current_path).to eq(admin_dashboard_path)
        within("#flash_message") { expect(page).to have_content("Admin: Welcome, #{admin.email}")}
      end
    end
  end
end
require "rails_helper"

RSpec.describe "Admin User Show" do
  describe "As an admin" do
    describe "When i visit a default user's show page" do
      it " I see users name at the top of the page " do
        admin = User.create!(name: "admin", email: "admin@admin.admin", password: "admin123", role: 1)

        user_1 = User.create!(name: "mike", email: "mike@aol.com", password: "password123")
        
        visit login_path

        fill_in :email, with: admin.email
        fill_in :password, with: admin.password

        click_on "Log In"
        click_on "mike@aol.com"

        expect(page).to have_content "Admin: Mike's Dashboard"
      end
    end
  end
end
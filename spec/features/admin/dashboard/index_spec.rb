require "rails_helper"

RSpec.describe "Admin Dashboard" do
  describe "As an admin" do
    it "can see a list of all default user's email addresses and when clicked, am taken to their '/admin/users/:id' page" do
      admin = User.create!(name: "admin", email: "admin@admin.admin", password: "admin123", role: 1)

      user_1 = User.create!(name: "mike", email: "mike@aol.com", password: "password123")
      user_2 = User.create!(name: "abdul", email: "abdul@aol.com", password: "password123")
      user_3 = User.create!(name: "adam", email: "adam@aol.com", password: "password123")

      visit login_path

      fill_in :email, with: admin.email
      fill_in :password, with: admin.password

      click_on "Log In"

      within("#default_users") {
        expect(page).to have_link("mike@aol.com", href: "/admin/users/#{user_1.id}")
        expect(page).to have_link("abdul@aol.com", href: "/admin/users/#{user_2.id}")
        expect(page).to have_link("adam@aol.com", href: "/admin/users/#{user_3.id}")
      }
    end
  end
end

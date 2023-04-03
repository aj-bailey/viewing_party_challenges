require "rails_helper"

RSpec.describe "New User Page" do
  describe "When a user visits the /register path they should see a form to register." do
    before(:each) do
      visit register_path
    end

    it "should see a form that requires name, email and register button which redirects to '/users/:id' page when filled in" do
      expect(page).to have_field(:user_name)
      expect(page).to have_field(:user_email)
      expect(page).to have_field(:user_password)
      expect(page).to have_field(:user_password_confirmation)
      expect(page).to have_button("Create New User")

      fill_in :user_name, with: "James"
      fill_in :user_email, with: "james@aol.com"
      fill_in :user_password, with: "password123"
      fill_in :user_password_confirmation, with: "password123"
      click_button "Create New User"

      expect(current_path).to eq(user_path(User.last))
    end

    it 'should not be able to submit the form without a name' do
      fill_in :user_email, with: "james@aol.com"
      fill_in :user_password, with: "password123"
      fill_in :user_password_confirmation, with: "password123"
      click_button "Create New User"

      expect(current_path).to eq(register_path)
      within("#flash_message") { expect(page).to have_content("Unable to create new user - [\"Name can't be blank\"]")}

      fill_in :user_name, with: "james"
      fill_in :user_password, with: "password123"
      fill_in :user_password_confirmation, with: "password123"
      click_button "Create New User"

      expect(current_path).to eq(register_path)
      within("#flash_message") { expect(page).to have_content("Unable to create new user - [\"Email can't be blank\"]")}
    end

    it 'should not be able to submit the form without a unique email' do
      User.create!(name: "mike", email: "mike@aol.com", password: "password123")

      fill_in :user_name, with: "mike"
      fill_in :user_email, with: "mike@aol.com"
      fill_in :user_password, with: "password123"
      fill_in :user_password_confirmation, with: "password123"
      click_button "Create New User"

      expect(current_path).to eq(register_path)
      within("#flash_message") { expect(page).to have_content("Unable to create new user - [\"Email has already been taken\"]")}
    end

    it "should not be able to submit the form without matching password and password confirmation values" do
      fill_in :user_name, with: "James"
      fill_in :user_email, with: "james@aol.com"
      fill_in :user_password, with: "password123"
      fill_in :user_password_confirmation, with: "password321"
      click_button "Create New User"

      expect(current_path).to eq(register_path)
      within("#flash_message") { expect(page).to have_content("Unable to create new user - [\"Password confirmation doesn't match Password\"]")}
    end
  end
end
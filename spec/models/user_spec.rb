require "rails_helper"

RSpec.describe User do
  describe 'relationships' do
    it { should have_many :viewing_party_users }
    it { should have_many(:viewing_parties).through(:viewing_party_users) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password_digest }
    it { should have_secure_password }
  end

  describe "creating a user" do
    it "should create a user with a password_digest column and not a password column" do
      user = User.create(name: "Meg", email: "meg@test.com", password: "password123", password_confirmation: "password123")

      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq("password123")
    end
  end

  describe "::class methods" do
    describe "#default_users" do
      it "returns a list of default users" do
        admin = User.create!(name: "admin", email: "admin@admin.admin", password: "admin123", role: 1)

        user_1 = User.create!(name: "mike", email: "mike@aol.com", password: "password123")
        user_2 = User.create!(name: "abdul", email: "abdul@aol.com", password: "password123")
        user_3 = User.create!(name: "adam", email: "adam@aol.com", password: "password123")

        expect(User.default_users).to eq([user_1, user_2, user_3])
      end
    end
  end
end
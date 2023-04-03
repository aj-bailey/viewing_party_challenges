require "rails_helper"

RSpec.describe ViewingParty do
  describe 'relationships' do
    it { should have_many :viewing_party_users }
    it { should have_many(:users).through(:viewing_party_users) }
  end
  #-------- unable to test validations due to custom validation --------#
  # describe 'validations' do
  #   it { should validate_presence_of :party_date }
  #   it { should validate_presence_of :party_time }
  # end
  #---------------------------------------------------------------------#
  
  describe '#instance methods' do
    before :each do
      @adam = User.create!( name: 'adam', email: 'adam@example.com', password: "test123", password_confirmation: "test123")
      @james = User.create!( name: 'james', email: 'james@example.com', password: "test123", password_confirmation: "test123")
      @mike = User.create!( name: 'mike', email: 'mike@example.com', password: "test123", password_confirmation: "test123")
      
      @fight_club = ViewingParty.create!( duration_minutes: 139, party_date: "2123-12-28", party_time: "1:39", host_id: @james.id, movie_id: 550 )

      ViewingPartyUser.create!(user_id: @james.id, viewing_party_id: @fight_club.id)
      ViewingPartyUser.create!(user_id: @mike.id, viewing_party_id: @fight_club.id)
      ViewingPartyUser.create!(user_id: @adam.id, viewing_party_id: @fight_club.id)
    end

    describe '#host', :vcr do
      it 'returns the host of the viewing party' do
        expect(@fight_club.host).to eq(@james)
      end
    end

    describe "#guest", :vcr do
      it 'returns the guest of the viewing party' do
        expect(@fight_club.guests).to eq([@adam, @mike])
      end
    end
  end
end
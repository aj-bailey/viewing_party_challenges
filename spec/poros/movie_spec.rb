require "rails_helper"

RSpec.describe Movie do
  describe "#instance methods", :vcr do
    before(:each) do
      @movie = MovieFacade.new({id: 550}).movie
    end

    describe "#initialize" do
      
      it 'exists' do
        expect(@movie).to be_a(Movie)
      end

      it 'has readable attributes' do
        expect(@movie.id).to eq(550)
        expect(@movie.title).to eq("Fight Club")
        expect(@movie.vote_average).to eq(8.431)
        expect(@movie.runtime).to eq(139)

        expect(@movie.genres).to eq(
          [
            {
              id: 18,
              name: "Drama"
            },
            {
              id: 53,
              name: "Thriller"
            },
            {
              id: 35,
              name: "Comedy"
            }
          ]
        )

        expect(@movie.summary).to eq("A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.")
        expect(@movie.image_path).to eq("/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")

        expect(@movie.reviews.first).to be_a(Review)
        expect(@movie.cast.first).to be_a(CastMember)
      end
    end

    describe "#create_reviews" do
      it 'should return all reviews for a movie in an array of review objects' do
        expect(@movie.reviews.count).to eq(8)
      end
    end

    describe "#create_cast" do
      it 'should return the first 10 cast members' do
        expect(@movie.cast.count).to eq(10)
      end
    end
  end
end
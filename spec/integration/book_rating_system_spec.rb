require 'rails_helper'

RSpec.describe 'Book Rating System Integration', type: :integration do
  let(:book) { create(:book, title: "Test Book", author: "Test Author") }
  let(:active_users) { create_list(:user, 5, :active) }
  let(:banned_users) { create_list(:user, 2, :banned) }

  describe 'Complete rating system workflow' do
    context 'when a new book is created' do
      it 'has no rating status initially' do
        expect(book.rating_status).to eq("Reseñas Insuficientes")
        expect(book.average_rating).to be_nil
        expect(book.valid_reviews_count).to eq(0)
      end
    end

    context 'when users start reviewing a book' do
      context 'with only 1 review' do
        before do
          create(:review, book: book, user: active_users[0], rating: 5, content: "Excellent book!")
        end

        it 'shows insufficient reviews status' do
          expect(book.rating_status).to eq("Reseñas Insuficientes")
          expect(book.valid_reviews_count).to eq(1)
          expect(book.average_rating).to eq(5.0)
        end
      end

      context 'with 2 reviews from active users' do
        before do
          create(:review, book: book, user: active_users[0], rating: 4, content: "Good read")
          create(:review, book: book, user: active_users[1], rating: 5, content: "Amazing!")
        end

        it 'still shows insufficient reviews status' do
          expect(book.rating_status).to eq("Reseñas Insuficientes")
          expect(book.valid_reviews_count).to eq(2)
          expect(book.average_rating).to eq(4.5)
        end
      end

      context 'with exactly 3 reviews from active users' do
        before do
          create(:review, book: book, user: active_users[0], rating: 4, content: "Good")
          create(:review, book: book, user: active_users[1], rating: 5, content: "Great")
          create(:review, book: book, user: active_users[2], rating: 3, content: "Okay")
        end

        it 'shows the average rating' do
          expect(book.rating_status).to eq("4.0")
          expect(book.valid_reviews_count).to eq(3)
          expect(book.average_rating).to eq(4.0)
        end
      end

      context 'with more than 3 reviews from active users' do
        before do
          create(:review, book: book, user: active_users[0], rating: 5)
          create(:review, book: book, user: active_users[1], rating: 4)
          create(:review, book: book, user: active_users[2], rating: 3)
          create(:review, book: book, user: active_users[3], rating: 2)
          create(:review, book: book, user: active_users[4], rating: 1)
        end

        it 'calculates and displays the correct average' do
          expect(book.rating_status).to eq("3.0")
          expect(book.valid_reviews_count).to eq(5)
          expect(book.average_rating).to eq(3.0)
        end
      end
    end

    context 'when banned users are involved' do
      context 'with 2 active user reviews and 3 banned user reviews' do
        before do
          create(:review, book: book, user: active_users[0], rating: 4)
          create(:review, book: book, user: active_users[1], rating: 5)
          
          create(:review, book: book, user: banned_users[0], rating: 1)
          create(:review, book: book, user: banned_users[1], rating: 1)
          create(:review, book: book, user: create(:user, :banned), rating: 1)
        end

        it 'ignores banned user reviews and shows insufficient status' do
          expect(book.reviews.count).to eq(5)  
          expect(book.valid_reviews_count).to eq(2)  
          expect(book.rating_status).to eq("Reseñas Insuficientes")
          expect(book.average_rating).to eq(4.5)  
        end
      end

      context 'with sufficient active reviews despite banned user reviews' do
        before do
          create(:review, book: book, user: active_users[0], rating: 5)
          create(:review, book: book, user: active_users[1], rating: 4)
          create(:review, book: book, user: active_users[2], rating: 3)
          
          create(:review, book: book, user: banned_users[0], rating: 1)
          create(:review, book: book, user: banned_users[1], rating: 2)
        end

        it 'shows average rating ignoring banned users' do
          expect(book.reviews.count).to eq(5)
          expect(book.valid_reviews_count).to eq(3)
          expect(book.rating_status).to eq("4.0")  # (5 + 4 + 3) / 3 = 4.0
          expect(book.average_rating).to eq(4.0)
        end
      end

      context 'when a user gets banned after reviewing' do
        let(:user_to_ban) { create(:user, :active) }
        
        before do
          create(:review, book: book, user: active_users[0], rating: 5)
          create(:review, book: book, user: active_users[1], rating: 4)
          create(:review, book: book, user: user_to_ban, rating: 3)
        end

        it 'updates rating when user status changes' do
          expect(book.rating_status).to eq("4.0")

          user_to_ban.update!(status: 'banned')

          expect(book.rating_status).to eq("Reseñas Insuficientes")
          expect(book.valid_reviews_count).to eq(2)
          expect(book.average_rating).to eq(4.5)
        end
      end
    end

    context 'decimal rounding scenarios' do
      context 'with ratings that produce various decimal results' do
        before do
          create(:review, book: book, user: active_users[0], rating: 4)
          create(:review, book: book, user: active_users[1], rating: 4)
          create(:review, book: book, user: active_users[2], rating: 5)
        end

        it 'rounds 4.333... to 4.3' do
          expect(book.average_rating).to eq(4.3)
          expect(book.rating_status).to eq("4.3")
        end
      end

      context 'with ratings producing 4.666...' do
        before do
          create(:review, book: book, user: active_users[0], rating: 5)
          create(:review, book: book, user: active_users[1], rating: 4)
          create(:review, book: book, user: active_users[2], rating: 5)
        end

        it 'rounds 4.666... to 4.7' do
          expect(book.average_rating).to eq(4.7)
          expect(book.rating_status).to eq("4.7")
        end
      end

      context 'with perfect integer average' do
        before do
          create(:review, book: book, user: active_users[0], rating: 3)
          create(:review, book: book, user: active_users[1], rating: 3)
          create(:review, book: book, user: active_users[2], rating: 3)
        end

        it 'shows .0 for integer results' do
          expect(book.average_rating).to eq(3.0)
          expect(book.rating_status).to eq("3.0")
        end
      end
    end

    context 'review content validation' do
      let(:user) { create(:user, :active) }

      it 'allows reviews with valid content length' do
        review = create(:review, book: book, user: user, rating: 4, content: "A" * 999)
        expect(review).to be_persisted
        expect(book.valid_reviews_count).to eq(1)
      end

      it 'allows reviews with exactly 1000 characters' do
        review = create(:review, book: book, user: user, rating: 4, content: "A" * 1000)
        expect(review).to be_persisted
      end

      it 'validates reviews cannot exceed 1000 characters' do
        review = build(:review, book: book, user: user, rating: 4, content: "A" * 1001)
        expect(review).not_to be_valid
        expect(review.errors[:content]).to include("is too long (maximum is 1000 characters)")
      end

      it 'raises database error when bypassing validations for content over 1000 chars' do
        review = create(:review, book: book, user: user, rating: 4, content: "short")
        
        expect {
          review.update_column(:content, "A" * 1001)
        }.to raise_error(ActiveRecord::StatementInvalid, /content_length/)
      end

      it 'allows reviews without content' do
        review = create(:review, book: book, user: user, rating: 4, content: nil)
        expect(review).to be_persisted
        expect(book.valid_reviews_count).to eq(1)
      end
    end

    context 'rating validation' do
      let(:user) { create(:user, :active) }

      it 'allows all valid ratings from 1 to 5' do
        (1..5).each do |rating|
          user_for_rating = create(:user, :active)
          review = create(:review, book: book, user: user_for_rating, rating: rating)
          expect(review).to be_persisted
        end
        expect(book.valid_reviews_count).to eq(5)
      end

      it 'validates ratings cannot be invalid' do
        [0, 6, -1, 10].each do |invalid_rating|
          review = build(:review, book: book, user: create(:user), rating: invalid_rating)
          expect(review).not_to be_valid
          expect(review.errors[:rating]).to include("is not included in the list")
        end
      end

      it 'raises database error when bypassing validations for rating below 1' do
        review = create(:review, book: book, user: user, rating: 3)
        
        expect {
          review.update_column(:rating, 0)
        }.to raise_error(ActiveRecord::StatementInvalid, /rating_range/)
      end

      it 'raises database error when bypassing validations for rating above 5' do
        review = create(:review, book: book, user: user, rating: 3)
        
        expect {
          review.update_column(:rating, 6)
        }.to raise_error(ActiveRecord::StatementInvalid, /rating_range/)
      end
    end

    context 'user uniqueness per book' do
      let(:user) { create(:user, :active) }

      it 'prevents multiple reviews from same user for same book' do
        create(:review, book: book, user: user, rating: 4)
        
        expect {
          build(:review, book: book, user: user, rating: 5).save!
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'allows same user to review different books' do
        other_book = create(:book)
        
        review1 = create(:review, book: book, user: user, rating: 4)
        review2 = create(:review, book: other_book, user: user, rating: 5)
        
        expect(review1).to be_persisted
        expect(review2).to be_persisted
      end
    end
  end

  describe 'Edge cases and error handling' do
    context 'when all reviews are from banned users' do
      before do
        create(:review, book: book, user: banned_users[0], rating: 3)
        create(:review, book: book, user: banned_users[1], rating: 4)
        create(:review, book: book, user: create(:user, :banned), rating: 5)
      end

      it 'handles the scenario gracefully' do
        expect(book.reviews.count).to eq(3)
        expect(book.valid_reviews_count).to eq(0)
        expect(book.average_rating).to be_nil
        expect(book.rating_status).to eq("Reseñas Insuficientes")
      end
    end

    context 'data consistency across operations' do
      it 'maintains consistency when reviews are deleted' do
        reviews = []
        5.times do |i|
          reviews << create(:review, book: book, user: active_users[i], rating: 4)
        end

        expect(book.rating_status).to eq("4.0")

        reviews.first(3).each(&:destroy)

        expect(book.valid_reviews_count).to eq(2)
        expect(book.rating_status).to eq("Reseñas Insuficientes")
      end
    end
  end
end
require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { build(:book) }
  describe 'associations' do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:users).through(:reviews) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_uniqueness_of(:title).scoped_to(:author) }
  end

  describe '#average_rating' do
    let(:book) { create(:book) }
    let(:active_user1) { create(:user, :active) }
    let(:active_user2) { create(:user, :active) }
    let(:active_user3) { create(:user, :active) }
    let(:banned_user) { create(:user, :banned) }

    context 'when book has no reviews' do
      it 'returns zero' do
        expect(book.average_rating).to be_zero
      end
    end

    context 'when book has reviews from active users only' do
      before do
        create(:review, book: book, user: active_user1, rating: 4)
        create(:review, book: book, user: active_user2, rating: 5)
        create(:review, book: book, user: active_user3, rating: 3)
      end

      it 'calculates the correct average' do
        expect(book.average_rating).to eq(4.0)
      end

      it 'rounds to one decimal place' do
        create(:review, book: book, user: create(:user), rating: 2)
        expect(book.average_rating).to eq(3.5)
      end
    end

    context 'when book has reviews from both active and banned users' do
      before do
        create(:review, book: book, user: active_user1, rating: 4)
        create(:review, book: book, user: active_user2, rating: 5)
        create(:review, book: book, user: banned_user, rating: 1)
      end

      it 'excludes reviews from banned users' do
        expect(book.average_rating).to eq(4.5)
      end
    end

    context 'when book has only reviews from banned users' do
      before do
        create(:review, book: book, user: banned_user, rating: 3)
      end

      it 'returns zero when all reviews are from banned users' do
        expect(book.average_rating).to be_zero
      end
    end

    context 'with decimal rounding scenarios' do
      before do
        create(:review, book: book, user: active_user1, rating: 4)
        create(:review, book: book, user: active_user2, rating: 4)
        create(:review, book: book, user: active_user3, rating: 5)
      end

      it 'rounds 4.333... to 4.3' do
        expect(book.average_rating).to eq(4.3)
      end
    end
  end

  describe '#rating_status' do
    let(:book) { create(:book) }
    let(:active_users) { create_list(:user, 5, :active) }

    context 'when book has less than 3 reviews from active users' do
      before do
        create(:review, book: book, user: active_users[0], rating: 4)
        create(:review, book: book, user: active_users[1], rating: 5)
      end

      it 'returns "Reseñas Insuficientes"' do
        expect(book.rating_status).to eq("Reseñas Insuficientes")
      end
    end

    context 'when book has less than 3 reviews total but some from banned users' do
      let(:banned_user) { create(:user, :banned) }
      
      before do
        create(:review, book: book, user: active_users[0], rating: 4)
        create(:review, book: book, user: active_users[1], rating: 5)
        create(:review, book: book, user: banned_user, rating: 3)
      end

      it 'returns "Reseñas Insuficientes" because banned reviews do not count' do
        expect(book.rating_status).to eq("Reseñas Insuficientes")
      end
    end

    context 'when book has 3 or more reviews from active users' do
      before do
        create(:review, book: book, user: active_users[0], rating: 4)
        create(:review, book: book, user: active_users[1], rating: 5)
        create(:review, book: book, user: active_users[2], rating: 3)
      end

      it 'returns the average rating' do
        expect(book.rating_status).to eq("4.0")
      end
    end

    context 'when book has exactly 3 reviews from active users' do
      before do
        create(:review, book: book, user: active_users[0], rating: 2)
        create(:review, book: book, user: active_users[1], rating: 3)
        create(:review, book: book, user: active_users[2], rating: 4)
      end

      it 'returns the average rating rounded to one decimal' do
        expect(book.rating_status).to eq("3.0")
      end
    end

    context 'when book has no reviews' do
      it 'returns "Reseñas Insuficientes"' do
        expect(book.rating_status).to eq("Reseñas Insuficientes")
      end
    end
  end

  describe '#valid_reviews_count' do
    let(:book) { create(:book) }
    let(:active_user) { create(:user, :active) }
    let(:banned_user) { create(:user, :banned) }

    it 'counts only reviews from active users' do
      create(:review, book: book, user: active_user, rating: 4)
      create(:review, book: book, user: banned_user, rating: 5)
      
      expect(book.valid_reviews_count).to eq(1)
    end

    it 'returns 0 when no reviews exist' do
      expect(book.valid_reviews_count).to eq(0)
    end
  end

  describe 'factory traits' do
    it 'creates books with insufficient reviews' do
      book = create(:book, :with_insufficient_reviews)
      expect(book.reviews.count).to eq(2)
    end

    it 'creates books with sufficient reviews' do
      book = create(:book, :with_sufficient_reviews)
      expect(book.reviews.count).to eq(5)
    end
  end
end
require 'rails_helper'

RSpec.describe Review, type: :model do
  subject { build(:review) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
    it { should validate_length_of(:content).is_at_most(1000) }
    it { should_not validate_presence_of(:content) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:book_id).with_message("can only review a book once") }
  end

  describe 'database constraints' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    context 'when rating is within valid range' do
      it 'allows ratings from 1 to 5' do
        (1..5).each do |rating|
          review = build(:review, user: user, book: book, rating: rating)
          expect(review).to be_valid
        end
      end
    end

    context 'when rating is outside valid range' do
      it 'validates rating cannot be below 1' do
        review = build(:review, user: user, book: book, rating: 0)
        expect(review).not_to be_valid
        expect(review.errors[:rating]).to include("is not included in the list")
      end

      it 'validates rating cannot be above 5' do
        review = build(:review, user: user, book: book, rating: 6)
        expect(review).not_to be_valid
        expect(review.errors[:rating]).to include("is not included in the list")
      end
    end

    context 'when content exceeds 1000 characters' do
      it 'validates content cannot exceed 1000 characters' do
        review = build(:review, :with_over_limit_content, user: user, book: book)
        expect(review).not_to be_valid
        expect(review.errors[:content]).to include("is too long (maximum is 1000 characters)")
      end

      it 'allows content at exactly 1000 characters' do
        review = build(:review, :with_max_content, user: user, book: book)
        expect(review).to be_valid
      end
    end

    context 'database level constraints when bypassing validations' do
      it 'raises database error for rating below 1 when bypassing validations' do
        review = build(:review, user: user, book: book, rating: 1)
        review.save!
        
        expect {
          review.update_column(:rating, 0)
        }.to raise_error(ActiveRecord::StatementInvalid, /rating_range/)
      end

      it 'raises database error for rating above 5 when bypassing validations' do
        review = build(:review, user: user, book: book, rating: 1)
        review.save!
        
        expect {
          review.update_column(:rating, 6)
        }.to raise_error(ActiveRecord::StatementInvalid, /rating_range/)
      end

      it 'raises database error for content over 1000 chars when bypassing validations' do
        review = build(:review, user: user, book: book, content: "short")
        review.save!
        
        expect {
          review.update_column(:content, 'a' * 1001)
        }.to raise_error(ActiveRecord::StatementInvalid, /content_length/)
      end
    end
  end

  describe 'scopes' do
    let(:active_user) { create(:user, :active) }
    let(:banned_user) { create(:user, :banned) }
    let(:book) { create(:book) }

    before do
      create(:review, user: active_user, book: book, rating: 4)
      create(:review, user: banned_user, book: book, rating: 5)
    end

    describe '.from_active_users' do
      it 'returns only reviews from active users' do
        expect(Review.from_active_users.count).to eq(1)
        expect(Review.from_active_users.first.user).to eq(active_user)
      end
      it 'excludes reviews from banned users' do
        banned_review_ids = Review.from_active_users.pluck(:user_id)
        expect(banned_review_ids).not_to include(banned_user.id)
      end
    end
  end

  describe 'factory traits' do
    it 'creates reviews with different ratings using traits' do
      excellent_review = create(:review, :excellent)
      poor_review = create(:review, :poor)
      
      expect(excellent_review.rating).to eq(5)
      expect(poor_review.rating).to eq(2)
    end
    it 'creates reviews from banned users' do
      banned_review = create(:review, :from_banned_user)
      expect(banned_review.user.status).to eq('banned')
    end
    it 'creates reviews without content' do
      review = create(:review, :without_content)
      expect(review.content).to be_nil
    end
  end

  describe 'uniqueness validation' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    it 'prevents multiple reviews from same user for same book' do
      create(:review, user: user, book: book, rating: 4)
      
      duplicate_review = build(:review, user: user, book: book, rating: 5)
      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:user_id]).to include("can only review a book once")
    end
    it 'allows same user to review different books' do
      other_book = create(:book)
      
      review1 = create(:review, user: user, book: book, rating: 4)
      review2 = build(:review, user: user, book: other_book, rating: 5)
      
      expect(review1).to be_persisted
      expect(review2).to be_valid
    end
    it 'allows different users to review same book' do
      other_user = create(:user)
      
      review1 = create(:review, user: user, book: book, rating: 4)
      review2 = build(:review, user: other_user, book: book, rating: 5)
      
      expect(review1).to be_persisted
      expect(review2).to be_valid
    end
  end
end
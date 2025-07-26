class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews

  validates :title, presence: true
  validates :author, presence: true
  validates :title, uniqueness: { scope: :author }

  def average_rating
    valid_ratings = reviews.joins(:user)
                          .where(users: { status: 'active' })
                          .pluck(:rating)
    
    return nil if valid_ratings.empty?
    
    average = valid_ratings.sum.to_f / valid_ratings.size
    average.round(1)
  end

  def rating_status
    return "Reseñas Insuficientes" if valid_reviews_count < 3
    
    average_rating.to_s
  end

  def valid_reviews_count
    reviews.joins(:user).where(users: { status: 'active' }).count
  end
end
class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, length: { maximum: 1000 }, allow_blank: true
  validates :user_id, uniqueness: { 
    scope: :book_id, 
    message: "can only review a book once" 
  }

  scope :from_active_users, -> { joins(:user).where(users: { status: 'active' }) }

  before_save :normalize_content

  private

  def normalize_content
    self.content = nil if content.blank?
  end
end
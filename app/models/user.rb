class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :books, through: :reviews

  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[active banned] }

  scope :active, -> { where(status: 'active') }
  scope :banned, -> { where(status: 'banned') }

  def active?
    status == 'active'
  end

  def banned?
    status == 'banned'
  end
end
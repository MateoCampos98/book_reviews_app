class ReviewFormComponent < ViewComponent::Base
  def initialize(review:, book:)
    @review = review
    @book = book
  end
end

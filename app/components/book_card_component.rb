class BookCardComponent < ViewComponent::Base
  def initialize(book:)
    @book = book
  end
end

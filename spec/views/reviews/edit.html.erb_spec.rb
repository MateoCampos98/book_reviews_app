require 'rails_helper'

RSpec.describe "reviews/edit", type: :view do
  let(:review) {
    Review.create!(
      user: nil,
      book: nil,
      rating: 1,
      content: "MyText"
    )
  }

  before(:each) do
    assign(:review, review)
  end

  it "renders the edit review form" do
    render

    assert_select "form[action=?][method=?]", review_path(review), "post" do

      assert_select "input[name=?]", "review[user_id]"

      assert_select "input[name=?]", "review[book_id]"

      assert_select "input[name=?]", "review[rating]"

      assert_select "textarea[name=?]", "review[content]"
    end
  end
end

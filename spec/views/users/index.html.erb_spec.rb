require 'rails_helper'

RSpec.describe "users/index", skip: "", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        email: "Email",
        user_name: "User Name",
        full_name: "Full Name",
        status: "Status"
      ),
      User.create!(
        email: "Email",
        user_name: "User Name",
        full_name: "Full Name",
        status: "Status"
      )
    ])
  end

  it "renders a list of users" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("User Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Full Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end

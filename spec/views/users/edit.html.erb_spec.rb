require 'rails_helper'

RSpec.describe "users/edit", skip: "", type: :view do
  let(:user) {
    User.create!(
      email: "MyString",
      user_name: "MyString",
      full_name: "MyString",
      status: "MyString"
    )
  }

  before(:each) do
    assign(:user, user)
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(user), "post" do

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[user_name]"

      assert_select "input[name=?]", "user[full_name]"

      assert_select "input[name=?]", "user[status]"
    end
  end
end

require 'rails_helper'

RSpec.describe "users/new", skip: "", type: :view do
  before(:each) do
    assign(:user, User.new(
      email: "MyString",
      user_name: "MyString",
      full_name: "MyString",
      status: "MyString"
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[user_name]"

      assert_select "input[name=?]", "user[full_name]"

      assert_select "input[name=?]", "user[status]"
    end
  end
end

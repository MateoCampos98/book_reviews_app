require 'rails_helper'

RSpec.describe "users/show", skip: "", type: :view do
  before(:each) do
    assign(:user, User.create!(
      email: "Email",
      user_name: "User Name",
      full_name: "Full Name",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/User Name/)
    expect(rendered).to match(/Full Name/)
    expect(rendered).to match(/Status/)
  end
end

module ReviewsHelper
  def ramdon_user
    faker_name = Faker::Name.name

    User.create!(
      email: "#{faker_name.gsub(' ', '.')}@example.com",
      user_name: faker_name,
      full_name: faker_name,
      status: "active"
    )
  end

  def review_params
    params.require(:review).permit(:user_id, :book_id, :rating, :content)
  end
end

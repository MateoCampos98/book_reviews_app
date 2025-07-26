FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    user_name { Faker::Internet.unique.username(specifier: 3..20, separators: %w[_]) }
    full_name { Faker::Name.name }
    status { 'active' }

    trait :active do
      status { 'active' }
    end

    trait :banned do
      status { 'banned' }
    end

    trait :with_specific_email do
      email { 'test@example.com' }
    end

    trait :with_specific_username do
      user_name { 'testuser' }
    end
  end
end
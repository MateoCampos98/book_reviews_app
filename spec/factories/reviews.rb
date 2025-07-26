FactoryBot.define do
  factory :review do
    association :user
    association :book
    rating { rand(1..5) }
    content { Faker::Lorem.paragraph(sentence_count: rand(2..5)) }

    trait :excellent do
      rating { 5 }
      content { "This book is absolutely amazing! #{Faker::Lorem.paragraph}" }
    end

    trait :good do
      rating { 4 }
      content { "Really good book, I enjoyed it. #{Faker::Lorem.paragraph}" }
    end

    trait :average do
      rating { 3 }
      content { "It was okay, not bad but not great either. #{Faker::Lorem.sentence}" }
    end

    trait :poor do
      rating { 2 }
      content { "Didn't really like it. #{Faker::Lorem.sentence}" }
    end

    trait :terrible do
      rating { 1 }
      content { "Waste of time. #{Faker::Lorem.sentence}" }
    end

    trait :without_content do
      content { nil }
    end

    trait :with_long_content do
      content { Faker::Lorem.characters(number: 950) }
    end

    trait :with_max_content do
      content { 'a' * 1000 }
    end

    trait :with_over_limit_content do
      content { 'a' * 1001 }
    end

    trait :from_active_user do
      association :user, :active
    end

    trait :from_banned_user do
      association :user, :banned
    end
  end
end

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    description { Faker::Lorem.paragraph(sentence_count: rand(3..8)) }

    trait :with_short_description do
      description { Faker::Lorem.sentence }
    end

    trait :with_long_description do
      description { Faker::Lorem.paragraph(sentence_count: 15) }
    end

    trait :classic do
      title { "#{Faker::Book.title} (Classic Edition)" }
      author { ['Charles Dickens', 'Jane Austen', 'Mark Twain'].sample }
    end

    trait :modern do
      title { "#{Faker::Book.title}: A Modern Tale" }
      author { Faker::Name.name }
    end

    trait :with_reviews do
      transient do
        reviews_count { 3 }
        average_rating { 4.0 }
      end

      after(:create) do |book, evaluator|
        ratings = generate_ratings_for_average(evaluator.reviews_count, evaluator.average_rating)
        ratings.each do |rating|
          create(:review, book: book, rating: rating)
        end
      end
    end

    trait :with_insufficient_reviews do
      after(:create) do |book|
        2.times { create(:review, book: book) }
      end
    end

    trait :with_sufficient_reviews do
      after(:create) do |book|
        5.times { create(:review, book: book) }
      end
    end
  end

  def self.generate_ratings_for_average(count, target_average)
    total = (target_average * count).round
    ratings = Array.new(count - 1) { rand(1..5) }
    last_rating = [1, [5, total - ratings.sum].min].max
    ratings << last_rating
    ratings.shuffle
  end
end

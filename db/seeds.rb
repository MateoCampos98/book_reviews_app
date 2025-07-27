require 'faker'

User.destroy_all
Book.destroy_all
Review.destroy_all

users = 20.times.map do |i|
  User.create!(
    email: "user#{i + 1}@example.com",
    user_name: "usuario#{i + 1}",
    full_name: Faker::Name.name,
    status: ["active", "banned"].sample
  )
end

books = 20.times.map do |i|
  Book.create!(
    title: Faker::Book.unique.title,
    author: Faker::Book.author,
    description: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

20.times do |i|
  reviewer = users[i]
  reviewed_book = books[(i + 1) % books.length]

  rating = rand(1..5)
  content =
    case rating
    when 1
      "No me gustó para nada, decepcionante."
    when 2
      "Esperaba mucho más de este libro."
    when 3
      "Tiene sus momentos, pero no me convenció."
    when 4
      "Muy bueno, aunque con algunos detalles."
    when 5
      "¡Excelente libro, lo recomiendo totalmente!"
    end

  Review.create!(
    user: reviewer,
    book: reviewed_book,
    rating: rating,
    content: content
  )
end

book_with_insufecent_reviews = 
  Book.create!(
    title: Faker::Book.unique.title,
    author: Faker::Book.author,
    description: Faker::Lorem.paragraph(sentence_count: 2)
  )

Review.create!(
  user: User.where(status: "active").last,
  book: book_with_insufecent_reviews,
  rating: 5,
  content: "Millonarios fc el más grande de el país"
)

puts "Se crearon #{User.count} usuarios, #{Book.count} libros y #{Review.count} reseñas."
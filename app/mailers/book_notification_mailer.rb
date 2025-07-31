class BookNotificationMailer < ApplicationMailer
  default from: "noreply@bookreviews.com"

  def new_review_notification(book, review, user)
    @book = book
    @review = review
    @user = user
    @book_url = book_url(@book)

    mail(
      to: @user.email,
      subject: "Nueva reseña para '#{@book.title}'" 
    )
  end

  def weekly_recommendations(user, recommended_books)
    @user = user
    @recommended_books = recommended_books

    mail(
      to: @user.email,
      subject: "Tus recomendaciones semanales de libros" 
    )
  end

  def review_approved(review)
    @review = review
    @book = review.book
    @user = review.user
      
    mail(
      to: @user.email,
      subject: "Tu reseña ha sido aprovada" 
    )
  end
end
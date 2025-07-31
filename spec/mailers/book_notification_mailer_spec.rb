require "rails_helper"

RSpec.describe BookNotificationMailer, type: :mailer do

  describe "new_review_notification" do
    let(:book) { create(:book) }
    let(:review) { create(:review, book: book) }
    let(:user) { create(:user) }
    let(:mail) { BookNotificationMailer.new_review_notification(book, review, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Nueva reseña para '#{book.title}'")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@bookreviews.com'])
    end
  
    it "renders the body" do
      expect(mail.body.encoded).to include(book.title)
      expect(mail.body.encoded).to include(review.content)
    end
  end

  describe "book_recommendations" do
    let(:user) { create(:user, user_name: "Andriu", email: "andriu@comunidadfeliz.com") }
    let(:recommended_books) { create_list(:book, 3, title:"Millonarios FC el mas grande") }
    let(:mail) { BookNotificationMailer.weekly_recommendations(user, recommended_books) }

    it "renders the body with book titles" do
      recommended_books.each do |book|
        expect(mail.body.encoded).to match(book.title)  
      end
    end

    it "mentions the user's name" do
      expect(mail.body.encoded).to include("Hola #{user.user_name}")  
    end 
  end

  describe "review appoved" do
    let(:review) { create(:review, approved: true) }
    let(:mail) { BookNotificationMailer.review_approved(review) }
  
    it "reviews to author" do
      expect(mail.to).to eq([review.user.email])   
    end

    it "mentions the books name" do
      expect(mail.body.encoded).to include(review.book.title)  
    end 
  end
end
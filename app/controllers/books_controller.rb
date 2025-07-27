class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  def index
    @books = Book.all
  end

  def show
  end

  def new
      @book = Book.find(params[:book_id])
      @review = @book.reviews.new
      render ReviewFormComponent.new(review: @review, book: @book)
  end

  def edit
  end

  def create
    def create
      @book = Book.find(params[:book_id])
      @review = @book.reviews.build(review_params)
  
      if @review.save
        redirect_to books_path, notice: "¡Reseña guardada!"
      else
        render ReviewFormComponent.new(review: @review, book: @book), status: :unprocessable_entity
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :description)
    end

    def review_params
      params.require(:review).permit(:score, :content)
    end
end

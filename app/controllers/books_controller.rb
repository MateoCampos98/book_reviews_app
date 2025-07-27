class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
      @book = Book.find(params[:book_id])
      @review = @book.reviews.new
      render ReviewFormComponent.new(review: @review, book: @book)
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
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

  # PATCH/PUT /books/1 or /books/1.json
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

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :description)
    end

    def review_params
      params.require(:review).permit(:score, :content)
    end
end

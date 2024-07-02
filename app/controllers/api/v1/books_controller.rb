class Api::V1::BooksController < ApplicationController

  def create
    @book = Book.create book_params

    if @book.valid?
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find params[:id]
    @book.destroy
    render status: :no_content
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end
end
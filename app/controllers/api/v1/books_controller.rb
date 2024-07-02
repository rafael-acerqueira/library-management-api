class Api::V1::BooksController < ApplicationController

  before_action :is_librarian?

  def create
    @book = Book.create book_params

    if @book.valid?
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    @book = Book.find_by(id: params[:id])

    if @book.present?
      if @book.update(book_params)
        render json: @book, status: :no_content

      else
        render json: @book.errors, status: :unprocessable_entity
      end
    else
      render json: @book, status: :not_found
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
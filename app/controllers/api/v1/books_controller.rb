class Api::V1::BooksController < ApplicationController

  before_action :is_librarian?, except: :search

  def create
    @book = Book.create book_params

    if @book.valid?
      render json: BookSerializer.new(@book).serializable_hash[:data][:attributes], status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    @book = Book.find_by(id: params[:id])

    if @book.present?
      if @book.update(book_params)
        render json: BookSerializer.new(@book).serializable_hash[:data][:attributes], status: :ok

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

  def search

    @books = Book.all

    @books = @books.where(title: params[:title]) if params[:title]

    @books = @books.where(author: params[:author]) if params[:author]

    @books = @books.where(genre: params[:genre]) if params[:genre]

    render json: @books, status: :ok
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end
end
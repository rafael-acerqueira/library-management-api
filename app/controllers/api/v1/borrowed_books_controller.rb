class Api::V1::BorrowedBooksController < ApplicationController

  def create
    @borrowed_book = BorrowedBook.new(borrowed_book_params.merge({
                                                    user: current_user,
                                                    borrowing_date: Date.today,
                                                    due_date: 2.weeks.from_now
                                                  }))

    @book = Book.find_by(id: borrowed_book_params[:book_id])

    if @borrowed_book.valid? && @book.is_available? && current_user.can_borrow?(@book)
      @borrowed_book.save
      render json: BorrowedBookSerializer.new(@borrowed_book).serializable_hash[:data][:attributes], status: :created
    else
      render json: @borrowed_book.errors, status: :unprocessable_entity
    end
  end

  private

  def borrowed_book_params
    params.require(:borrowed_book).permit(:book_id)
  end
end
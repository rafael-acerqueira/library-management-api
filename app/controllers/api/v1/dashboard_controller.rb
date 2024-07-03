class Api::V1::DashboardController < ApplicationController

  def index

    if current_user.librarian?

      total_books = Book.pluck(:total_copies).inject(&:+)

      total_borrowed_books = BorrowedBook.includes(:book, :user).where(returned: false)

      books_due_today = total_borrowed_books.select do |borrowed|
        borrowed.due_date.today?
      end

      books_due_today = books_due_today.map do |borrowed|
        {
          title: borrowed.book.title,
          author: borrowed.book.author
        }
      end

      members_overdue_book = total_borrowed_books.select do |borrowed|
        borrowed.due_date < Date.today
      end

      members_overdue_book = members_overdue_book.map do |borrowed|
        { email: borrowed.user.email}
      end

      data = {
        total_books: total_books,
        total_borrowed_books: total_borrowed_books.count,
        books_due_today: books_due_today,
        members_overdue_book: members_overdue_book
      }

      render json: data, status: :ok

    else
      books_borrowed = current_user.borrowed_books.map do |borrowed|
        {
          title: borrowed.book.title,
          author: borrowed.book.author,
          due_date: borrowed.due_date,
          overdue: borrowed.due_date < Date.today && !borrowed.returned
        }
      end

      render json: books_borrowed, status: :ok

    end
  end
end
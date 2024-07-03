class Book < ApplicationRecord
  validates :title, :author, :genre, :isbn, :total_copies, presence: true

  has_many :borrowed_books
  has_many :users, through: :borrowed_books


  def is_available?
    borrowed_books.where(returned: false).count < total_copies
  end
end

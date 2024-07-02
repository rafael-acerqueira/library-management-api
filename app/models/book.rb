class Book < ApplicationRecord
  validates :title, :author, :genre, :isbn, :total_copies, presence: true
end

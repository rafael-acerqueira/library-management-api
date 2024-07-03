class BorrowedBookSerializer
  include JSONAPI::Serializer
  attributes :id, :book_id, :user_id, :borrowing_date, :due_date, :returned
end

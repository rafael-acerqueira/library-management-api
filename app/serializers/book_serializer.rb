class BookSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :author, :isbn, :genre, :total_copies
end

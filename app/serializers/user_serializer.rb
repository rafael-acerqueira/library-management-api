class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :librarian
end

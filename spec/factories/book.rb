FactoryBot.define do
  factory :book do
    title {Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    isbn { Faker::Code.isbn }
    total_copies { Faker::Number.within(range: 1..10) }
  end
end
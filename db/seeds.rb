User.destroy_all
Book.destroy_all


User.create( email: Faker::Internet.email,
             password: '123456',
             librarian: true
            )

User.create( email: Faker::Internet.email,
            password: '123456',
            librarian: false
            )

10.times do
  Book.create(
    title:         Faker::Book.title,
    author:        Faker::Book.author,
    genre:         Faker::Book.genre,
    isbn:          Faker::Code.isbn,
    total_copies:  Faker::Number.within(range: 1..10)
  )
end
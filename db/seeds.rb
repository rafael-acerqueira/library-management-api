User.destroy_all
Book.destroy_all
BorrowedBook.destroy_all


librarian = User.create( email: Faker::Internet.email,
             password: '123456',
             librarian: true
            )

member = User.create( email: Faker::Internet.email,
            password: '123456',
            librarian: false
            )

user = User.create( email: Faker::Internet.email,
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

books = Book.all

BorrowedBook.create(book: books[0], user: member, borrowing_date: '2024-06-01', due_date: '2024-06-16')
BorrowedBook.create(book: books[1], user: member, borrowing_date: '2024-06-15', due_date: '2024-06-30', returned: true)
BorrowedBook.create(book: books[2], user: user, borrowing_date: '2024-06-01', due_date: '2024-06-16')
BorrowedBook.create(book: books[3], user: user, borrowing_date: '2024-07-01', due_date: '2024-07-16')
BorrowedBook.create(book: books[4], user: user, borrowing_date: '2024-07-01', due_date: Date.today)
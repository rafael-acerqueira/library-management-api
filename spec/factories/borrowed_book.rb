FactoryBot.define do
  factory :borrowed_book do
    book { book }
    user { user }
    borrowing_date { Date.today }
    due_date { 2.weeks.from_now }
    returned { false }
  end
end
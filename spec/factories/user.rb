FactoryBot.define do
  factory :user do
    email {Faker::Internet.email }
    password {Faker::Internet.password}
    librarian { false }

    trait :librarian do
      librarian { true }
    end

  end
end
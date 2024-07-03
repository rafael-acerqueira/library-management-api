class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self


  has_many :borrowed_books
  has_many :books, through: :borrowed_books


  def can_borrow? book_id
    borrowed_books.where(book_id: book_id, returned: false).count.zero?
  end
end

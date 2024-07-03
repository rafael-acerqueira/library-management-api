class CreateBorrowedBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :borrowed_books do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :borrowing_date
      t.date :due_date
      t.boolean :returned, default: false

      t.timestamps
    end
  end
end

require 'rails_helper'

RSpec.describe Book, :type => :model do

  let(:book) { FactoryBot.create(:book, total_copies: 2) }

  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }

  describe "#is_available?" do

    context "if the number of returned book is greater than total copies" do
      let!(:borrowed_book) do
        FactoryBot.create(:borrowed_book, user: user_1, book: book, returned: false)
      end

      it "return true" do
        expect(book.is_available?).to be true
      end
    end


    context "if the number of returned book is less than or igual the total copies" do
      let!(:borrowed_book) do
        FactoryBot.create(:borrowed_book, user: user_1, book: book)
      end

      let!(:borrowed_book_2) do
        FactoryBot.create(:borrowed_book, user: user_2, book: book)
      end

      it "return false" do
        expect(book.is_available?).to be false
      end
    end
  end
end
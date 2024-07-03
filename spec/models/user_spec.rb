require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:book) { FactoryBot.create(:book, total_copies: 2) }

  let(:book_2) { FactoryBot.create(:book, total_copies: 1) }

  let(:user) { FactoryBot.create(:user) }

  describe "#can_borrow?" do

    context "if user already have borrowed one copy of that book and didn't returned it" do
      let!(:borrowed_book) do
        FactoryBot.create(:borrowed_book, user: user, book: book, returned: false)
      end

      context "and try to borrow the same book" do
        it "return false" do
          expect(user.can_borrow?(book)).to be false
        end
      end

      context "and borrow another book" do
        it "return true" do
          expect(user.can_borrow?(book_2)).to be true
        end
      end
    end

    context "if user borrowed one copy of that book and returned it" do
      let!(:borrowed_book) do
        FactoryBot.create(:borrowed_book, user: user, book: book, returned: true)
      end

      it "return true" do
        expect(user.can_borrow?(book)).to be true
      end
    end

    context "if user don't borrow a copy of that book" do
      it "return true" do
        expect(user.can_borrow?(book)).to be true
      end
    end
  end
end
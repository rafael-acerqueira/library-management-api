require 'rails_helper'

RSpec.describe 'Borrowed Book', type: :request do
  describe 'POST /create' do
    context 'with valid parameters' do
      let(:book_valid_parameters) { FactoryBot.create(:book) }
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as(user)
        post '/api/v1/borrowed_books', params: { borrowed_book: { book_id: book_valid_parameters.id } }
      end

      it 'returns the book_id' do
        expect(json["book_id"]).to eq(book_valid_parameters.id)
      end

      it 'returns the user_id' do
        expect(json["user_id"]).to eq(user.id)
      end

      it 'returns the borrowing_date' do
        expect(json["borrowing_date"]).to eq(Date.today.strftime("%Y-%m-%d"))
      end

      it 'returns the due_date' do
        expect(json["due_date"]).to eq(2.weeks.from_now.strftime("%Y-%m-%d"))
      end

      it 'returns the returned' do
        expect(json["returned"]).to be false
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as(user)
        post '/api/v1/borrowed_books', params: {borrowed_book: { book_id: 0 }}
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'already have a copy of this book' do
      let(:book) { FactoryBot.create(:book) }
      let(:user) { FactoryBot.create(:user) }

      let!(:borrowed_book) do
        FactoryBot.create(:borrowed_book, user: user, book: book)
      end


      before do
        login_as(user)
        post '/api/v1/borrowed_books', params: { borrowed_book: { book_id: book.id } }
      end

      it 'should not borrow the same book twice' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end

    context 'book availability' do
      let!(:book_availability) { FactoryBot.create(:book, total_copies: 2) }

      let!(:user) { FactoryBot.create(:user) }
      let!(:user_2) { FactoryBot.create(:user) }
      let!(:user_3) { FactoryBot.create(:user) }

      before do
        login_as(user_3)
        post '/api/v1/borrowed_books', params: { borrowed_book: { book_id: book_availability.id } }
      end

      context 'book is unavailable' do
        let!(:borrowed_book) do
          FactoryBot.create(:borrowed_book, user: user, book: book_availability)
        end

        let!(:borrowed_book_2) do
          FactoryBot.create(:borrowed_book, user: user_2, book: book_availability)
        end

        it 'should not borrow an unavailable book' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'book is available' do
        let!(:borrowed_book) do
          FactoryBot.create(:borrowed_book, user: user, book: book_availability)
        end

        it 'should borrow an available book' do
          expect(response).to have_http_status(:created)
        end
      end
    end
  end
end
require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'POST /create' do
    context 'with valid parameters and librarian user' do
      let(:book) { FactoryBot.create(:book) }
      let(:user) { FactoryBot.create(:user, :librarian) }


      before do
        login_as(user)
        post '/api/v1/books', params:
                          { book: {
                            title: book.title,
                            author: book.author,
                            genre: book.genre,
                            isbn: book.isbn,
                            total_copies: book.total_copies,
                          } }
      end

      it 'returns the title' do
        expect(JSON.parse(response.body)['title']).to eq(book.title)
      end

      it 'returns the author' do
        expect(JSON.parse(response.body)['author']).to eq(book.author)
      end

      it 'returns the genre' do
        expect(JSON.parse(response.body)['genre']).to eq(book.genre)
      end

      it 'returns the isbn' do
        expect(JSON.parse(response.body)['isbn']).to eq(book.isbn)
      end

      it 'returns the total_copies' do
        expect(JSON.parse(response.body)['total_copies']).to eq(book.total_copies)
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters and librarian user' do
      let(:user) { FactoryBot.create(:user, :librarian) }
      before do
        login_as(user)
        post '/api/v1/books', params:
                          { book: {
                            title: ''
                          } }
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'common user' do
      let(:user) { FactoryBot.create(:user) }
      before do
        login_as(user)
        post '/api/v1/books', params:
                          { book: {
                            title: ''
                          } }
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /update" do
    let(:book) { FactoryBot.create(:book) }
    let(:user) { FactoryBot.create(:user, :librarian) }

    context 'with valid parameters and librarian user' do

      let(:valid_attributes) {{
        title: 'Title 1',
        author: 'Rafael',
        genre: 'Humor',
        isbn: '55AS5-5',
        total_copies: 2,
      }}

      before do
        login_as(user)
        put "/api/v1/books/#{book_id}", params: { book: valid_attributes }
      end

      context 'when book exists' do
        let(:book_id) { book.id }
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
        it 'updates the book' do
          updated_item = Book.find(book.id)
          expect(updated_item.title).to match(valid_attributes[:title])
        end
      end

      context 'when the book does not exist' do
        let(:book_id) { 0 }
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
        it 'returns a not found message' do
          expect(response.body).to include("null")
        end
      end

      context 'common user' do
        let(:user) { FactoryBot.create(:user) }
        let(:book_id) { book.id }
        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'with invalid parameters and librarian user' do
      let(:user) { FactoryBot.create(:user, :librarian) }
      before do
        login_as(user)
        put "/api/v1/books/#{book.id}", params: { book: { title: '' } }
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:book) { FactoryBot.create(:book) }

    before do
      login_as(user)
      delete "/api/v1/books/#{book.id}"
    end

    context "librarian user" do
      let(:user) { FactoryBot.create(:user, :librarian) }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context "common user" do
      let(:user) { FactoryBot.create(:user) }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
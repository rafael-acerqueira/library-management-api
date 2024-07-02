require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'POST /create' do
    context 'with valid parameters' do
      let(:book) { FactoryBot.create(:book) }

      before do
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

    context 'with invalid parameters' do
      before do
        post '/api/v1/books', params:
                          { book: {
                            title: ''
                          } }
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
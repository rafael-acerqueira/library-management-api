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
        expect(json["title"]).to eq(book.title)
      end

      it 'returns the author' do
        expect(json["author"]).to eq(book.author)
      end

      it 'returns the genre' do
        expect(json["genre"]).to eq(book.genre)
      end

      it 'returns the isbn' do
        expect(json["isbn"]).to eq(book.isbn)
      end

      it 'returns the total_copies' do
        expect(json["total_copies"]).to eq(book.total_copies)
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
          expect(response).to have_http_status(:no_content)
        end
        it 'updates the book' do
          updated_item = Book.find(book.id)
          expect(updated_item.title).to match(valid_attributes[:title])
        end
      end

      context 'when the book does not exist' do
        let(:book_id) { 0 }
        it 'returns status code 404' do
          expect(response).to have_http_status(:not_found)
        end
        it 'returns a not found message' do
          expect(response.body).to include("null")
        end
      end

      context 'common user' do
        let(:user) { FactoryBot.create(:user) }
        let(:book_id) { book.id }
        it 'returns status code 401' do
          expect(response).to have_http_status(:unauthorized)
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
        expect(response).to have_http_status(:no_content)
      end
    end

    context "common user" do
      let(:user) { FactoryBot.create(:user) }
      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /search" do
    context "librarian user" do
      let!(:book_1) {
        FactoryBot.create(:book,
          title: "The Lost Symbol",
          author: "Dan Brown",
          genre: "Fiction"
        )
      }

      let!(:book_2) {
        FactoryBot.create(:book,
        title: "The Hobbit",
        author: "J. R. R. Tolkien",
        genre: "Fantasy")
      }

      let!(:book_3) {
        FactoryBot.create(:book,
        title: "Harry Potter and the Goblet of Fire",
        author: "JK Rowling",
        genre: "Fantasy")
      }

      let!(:book_4) {
        FactoryBot.create(:book,
        title: "Harry Potter and the Prisoner of Azkaban",
        author: "JK Rowling",
        genre: "Fantasy")
      }

      let(:user) { FactoryBot.create(:user, :librarian) }

      before do
        login_as(user)
      end

      context "found books by title" do
        before do
          get "/api/v1/books/search", params: { title: book_1.title }
        end

        it 'should list books' do
          expect(json.length).to eq(1)
          expect(json[0]["title"]).to eq(book_1.title)
          expect(json[0]["author"]).to eq(book_1.author)
          expect(json[0]["genre"]).to eq(book_1.genre)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context "found books by author" do
        before do
          get "/api/v1/books/search", params: { author: book_3.author }
        end

        it 'should list books' do
          expect(json.length).to eq(2)
          expect(json[0]["title"]).to eq(book_3.title)
          expect(json[0]["author"]).to eq(book_3.author)
          expect(json[0]["genre"]).to eq(book_3.genre)

          expect(json[1]["title"]).to eq(book_4.title)
          expect(json[1]["author"]).to eq(book_4.author)
          expect(json[1]["genre"]).to eq(book_4.genre)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context "found books by genre" do
        before do
          get "/api/v1/books/search", params: { genre: book_4.genre }
        end

        it 'should list books' do
          expect(json.length).to eq(3)

          expect(json[0]["title"]).to eq(book_2.title)
          expect(json[0]["author"]).to eq(book_2.author)
          expect(json[0]["genre"]).to eq(book_2.genre)

          expect(json[1]["title"]).to eq(book_3.title)
          expect(json[1]["author"]).to eq(book_3.author)
          expect(json[1]["genre"]).to eq(book_3.genre)

          expect(json[2]["title"]).to eq(book_4.title)
          expect(json[2]["author"]).to eq(book_4.author)
          expect(json[2]["genre"]).to eq(book_4.genre)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context "found books by more than one filter" do
        before do
          get "/api/v1/books/search", params: {
                                                genre: book_4.genre,
                                                author: book_4.author
                                              }
        end

        it 'should list books' do
          expect(json.length).to eq(2)

          expect(json[0]["title"]).to eq(book_3.title)
          expect(json[0]["author"]).to eq(book_3.author)
          expect(json[0]["genre"]).to eq(book_3.genre)

          expect(json[1]["title"]).to eq(book_4.title)
          expect(json[1]["author"]).to eq(book_4.author)
          expect(json[1]["genre"]).to eq(book_4.genre)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "common user" do
      let(:user) { FactoryBot.create(:user) }
      let(:book) { FactoryBot.create(:book)}

      before do
        login_as(user)
        get "/api/v1/books/search", params: { title: book.title }
      end

      it 'should list books' do
        expect(json.length).to eq(1)
        expect(json[0]["title"]).to eq(book.title)
        expect(json[0]["author"]).to eq(book.author)
        expect(json[0]["genre"]).to eq(book.genre)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
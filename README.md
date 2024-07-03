## Setup Project

 `docker compose build `

 `docker compose run web rails db:create db:migrate db:seed`

 `docker compose up`

## Acess project
 The base URL is `http://localhost:3001/`


## Endpoints

Search: `GET` `/api/v1/books/search`

Books: `POST` `/api/v1/books` and `GET` `PUT` `PATCH` `DELETE` `/api/v1/books/:id`

Borrow Books: `POST` `/api/v1/borrowed_books`

Mark Book as returned: `PATCH` `/api/v1/borrowed_books/:id`

Dashboard: `GET` `/api/v1/dashboard`


## Thought Process
- Create a project API only and configure Docker and Docker Compose
- Started configuring registration/auth with Devise and JWT. I had some problems with Devise configuring registration controllers and Rspec
- Create Books following the TDD
- Create the search function
- Add serializers
- Fill out custom Devise controllers. After adding the librarian field
- User can borrow a book
- Librarian mark book as returned
- Add Dashboard functionality(I had some troubles with tests here, so I skip it, the deadline was close and I couldn't spend more time search for a solution)


## What I was thinking when I started
- Complete the test with the bonus part. I started with the Rails API only, creating the endpoints following the TDD
- Finish with a React frontend app. This is why I changed the port to 3001 in the Rails configuration, my plan was to have a React app running at port 3000

## What I have done
- Completed the API part without 100% coverage in the endpoints
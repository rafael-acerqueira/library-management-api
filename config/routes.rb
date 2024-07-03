Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :books, except: :index do
        get :search, on: :collection
      end

      resources :borrowed_books, only: [:create, :update]
      resources :dashboard, only: :index
    end
  end
end
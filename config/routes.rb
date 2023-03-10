Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "expenses#index"

  resources :expenses

  resources :users, only: [:index] do
    member do
      get :show_expenses
    end
  end
end

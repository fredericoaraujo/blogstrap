Rails.application.routes.draw do
  root 'articles#index'

  resources :articles
  resources :categories, except: %i[show]
end

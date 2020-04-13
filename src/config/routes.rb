Rails.application.routes.draw do
  root 'home#top'
  devise_for :users
  resources :books, except: :new 
end

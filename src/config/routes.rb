Rails.application.routes.draw do
  root 'home#top'
  resources :books, except: :new 
end

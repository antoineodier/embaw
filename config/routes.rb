Rails.application.routes.draw do
  devise_for :users
  resources :transcriptions, only: [:show]
end

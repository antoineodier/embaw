Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  resources :transcriptions, only: [:show]
  get "/transcriptions/submit_correction", to: 'transcriptions#submit_correction'
end

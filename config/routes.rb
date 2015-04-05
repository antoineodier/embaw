Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  resources :transcriptions, only: [:show]
  post "/transcriptions/:id/submit_correction", to: 'transcriptions#submit_correction', as: 'submit_correction'
end

Rails.application.routes.draw do
  # get 'static_pages/root'
  root 'static_pages#root'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # csv#import_csv - csv doesn't need the contorller part
  post '/import_csv', to: 'csv#import_csv'
  get '/test', to: 'csv#import_csv'
end

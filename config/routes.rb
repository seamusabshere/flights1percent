Flights1percent::Application.routes.draw do

  resources :domiciles

  resources :aircraft_registrations

  get "people" => "people#edit"
  post "people" => "people#update"
  
  resources :aircraft_models

  resources :aircraft

  resources :flights
  
  
  root :to => "pages#travel"

end


Flights1percent::Application.routes.draw do

  resources :fancy_houses

  resources :domiciles

  resources :aircraft_registrations

  get "people" => "people#edit"
  post "people" => "people#update"
  
  resources :aircraft_models

  resources :aircraft

  resources :flights
  
  
  root :to => "pages#travel"

end


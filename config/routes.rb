Flights1percent::Application.routes.draw do

  resources :aircraft_registrations

  resources :people

  resources :aircraft_models

  resources :aircraft


  resources :flights
  root :to => "pages#home"

end


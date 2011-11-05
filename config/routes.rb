Flights1percent::Application.routes.draw do
  resources :flights
  root :to => "pages#home"

end


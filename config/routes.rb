Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/checkout' => 'paypal#checkout'
  get '/execute' => 'paypal#execute'

  resources :main
end

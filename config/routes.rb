Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect('/api-docs')


  get 'prices/btc_to_usd', to: 'prices#show'
  resources :users, only: [] do
    resources :transactions, only: [:index, :show, :create]
  end
end

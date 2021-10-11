Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'pokemons/search/*query' => 'pokemons#search'
      resources :pokemons , only: [:index, :show, :create, :update , :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  namespace :admin do
    namespace :v1 do
      get "home" => "home#index"

      resources :categories
      resources :products
      resources :system_requirements
      resources :coupons
      resources :users
      resources :licenses
    end
  end

  namespace :storefront do
    namespace :v1 do

    end
  end
end

Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'users#new'

  post 'users/create' => 'users#create'
  get 'refer-a-friend' => 'users#refer'
  get 'privacy-policy' => 'users#policy'
  get 'subscribe' => 'users#new_index'
  get 'already-subscribe' => 'users#already_subscribe'
  post 'check_email' => 'users#check_email'
  get 'verification' => 'users#verification_user_email'

  unless Rails.application.config.consider_all_requests_local
    get '*not_found', to: 'users#redirect', format: false
  end
  resources :payments, only: [ :new, :create, :success_order ]
end

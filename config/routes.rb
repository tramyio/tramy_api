Rails.application.routes.draw do
  get 'current_user', to: 'current_user#index'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :chats, only: %i[index show create update]
  resources :leads, only: %i[index show create update]
  resources :stages, only: %i[index show create update]
  resources :pipelines, only: %i[index show create update]
  resources :organizations, only: %i[show create update]

  namespace :hookdeck do
    post 'messages/webhook'
  end

  patch 'chats/:id/new_message', to: 'chats#new_message'
  get '/chats_assigned_to_me', to: 'chats#assigned_to_me'
  get '/chats_not_assigned', to: 'chats#not_assigned'
  get 'chats/:id/notes', to: 'chats#list_notes'

  get 'accounts', to: 'accounts#index'

end

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

  namespace :hookdeck do
    post 'messages/webhook'
  end

  post 'message', to: 'chats#create_message'
end

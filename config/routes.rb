# frozen_string_literal: true

Rails.application.routes.draw do
  get 'current_user', to: 'current_user#index'

  devise_for :users, path: '',
                     path_names: {
                       sign_in: 'login',
                       sign_out: 'logout',
                       registration: 'signup'
                     },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  namespace :hookdeck do
    post 'messages/webhook'
  end

  resources :chats, only: %i[index show update] # Chat (All) / Chat (Detailed chat) / Chat (Reassign agent)
  resources :leads, only: %i[index show create update]
  resources :stages, only: %i[index]
  resources :pipelines, only: %i[index create update]
  resources :organizations, only: %i[show create update]

  patch 'chats/:id/new_message', to: 'chats#new_message'  #  Chat (New message)
  get '/chats_assigned_to_me', to: 'chats#assigned_to_me' #  Chat (Assigned to me)
  get '/chats_not_assigned', to: 'chats#not_assigned' # Chat (Unassigned)
  get 'chats/:id/notes', to: 'chats#list_notes' # Chat (Get notes)

  get 'accounts', to: 'accounts#index' # Team / Chat (List of agents)
  get 'my_account', to: 'accounts#show' # Profile
end

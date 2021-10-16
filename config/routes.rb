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
  resources :stages, only: %i[index update]
  resources :pipelines, only: %i[index create update]
  resources :organizations, only: %i[create]

  # List for funnel module
  get 'pipelines/:pipeline_id/leads_by_stage', to: 'pipelines#list_pipeline_stage_leads'

  # Organization
  get 'my_organization', to: 'organizations#show'
  patch 'my_organization', to: 'organizations#update'

  # Profile
  get 'my_profile', to: 'profiles#show' # Get my profile
  patch 'my_profile', to: 'profiles#update' # Update my profile

  # Chat
  patch 'chats/:id/new_message', to: 'chats#new_message'  #  Chat (New message)
  get '/chats_assigned_to_me', to: 'chats#assigned_to_me' #  Chat (Assigned to me)
  get '/chats_not_assigned', to: 'chats#not_assigned' # Chat (Unassigned)
  get 'chats/:id/notes', to: 'chats#list_notes' # Chat (Get notes)
  post 'chats/:id/notes', to: 'chats#append_note' # Chat (Get notes)

  # Account
  get 'accounts', to: 'accounts#index' # Team / Chat (List of agents)

  # Media retrieve ("proxy-like")
  get 'retrieve_media/:media_id', to: 'chats#retrieve_media'
end

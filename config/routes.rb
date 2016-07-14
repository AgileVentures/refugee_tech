Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  apipie

  root to: 'application#welcome'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :languages, except: [:new, :edit]
      get 'user/languages', to: 'languages#my_languages'
      resources :users, only: [:index, :show], constraints: {format: /(json)/}
      get 'unify/:id', controller: :users, action: :unify, as: :unify, constraints: {format: /(json)/}
      post 'skills/:id', controller: :users, action: :skills, as: :skills, constraints: {format: /(json)/}
      get 'user/:id/friendship/:friend_id', controller: :users, action: :friendship, as: :friendship,constraints: {format: /(json)/}
      get 'user/:id/friendship/:friend_id/confirm', controller: :users, action: :confirm_friendship , as: :confirm_friendship, constraints: {format: /(json)/}
      get 'user/:id/friendship/:friend_id/block', controller: :users, action: :block_friendship , as: :block_friendship, constraints: {format: /(json)/}
      resources :activities, only: [:index]
      post 'mailbox/conversations/compose', controller: :mailbox, action: :compose, as: :mailbox_compose
      post 'mailbox/conversations/reply', controller: :mailbox, action: :reply, as: :mailbox_reply
      post 'mailbox/conversations/update', controller: :mailbox, action: :update, as: :mailbox_update
      get 'mailbox/conversations', controller: :mailbox, action: :inbox, as: :mailbox_inbox
      get 'mailbox/conversations/trash', controller: :mailbox, action: :trash, as: :mailbox_trash
      get 'mailbox/conversations/messages_count', controller: :mailbox, action: :messages_count, as: :messages_count
    end
    
    namespace :v0 do
      resources :ping, only: [:index], constraints: {format: /(json)/}
    end

  end
  devise_for :users,
             path: 'api/v1/users',
             controllers: {registrations: 'api/v1/registrations',
                           sessions: 'api/v1/sessions',
                           omniauth_callbacks: 'api/v1/omniauth_callbacks',
                           application: 'api'}
  resources :users
  resources :tags, as: 'acts_as_taggable_on_tag'
  resource :session, only: [:new, :create, :destroy]

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

end

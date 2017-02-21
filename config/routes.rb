Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post '/login', to: 'users#login', as: 'login'
        end
      end
      resources :conversations do
        collection do
          post '/list', to: 'conversations#get_all_conversations', as: 'list'
          post '/send', to: 'conversations#send_message', as: 'send'
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Chatboard::Application.routes.draw do
  resources :rooms do
    collection do
      get :slide, action: :slide, as: :slide
      get 'mb/:serial(/:tag)', action: 'mb_show', as: 'mb'
      post :mb, action: 'mb_post', as: 'mb'
    end
  end

  root :to => 'rooms#top'
  get 'sessions/destroy'

  get '/auth/:provider/callback', :to => 'sessions#callback'
  post '/auth/:provider/callback', :to => 'sessions#callback'
end

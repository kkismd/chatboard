Chatboard::Application.routes.draw do
  resources :rooms do
    collection do
      get 'mb/:serial', :action => 'mb_show', :as => 'mb'
      post :mb, :action => 'mb_post', :as => 'mb'
    end
  end

  root :to => 'rooms#top'
end

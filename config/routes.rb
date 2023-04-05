Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 
  
  devise_scope :user do
    get "users/sign_up", :to => "users/registrations#new"
    get "users/sign_in", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'articles#index'
  get 'articles/new', to: 'articles#new'
  post 'articles/create', to: 'articles#create'
  get 'articles/:id', to: 'articles#show'
  get 'articles/:id/edit', to: 'articles#edit'
  post 'articles/:id/update', to: 'articles#update'
  post 'articles/:id/destroy', to: 'articles#destroy'
end

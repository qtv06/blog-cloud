Rails.application.routes.draw do
  get 'posts/index'
  root "home_pages#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

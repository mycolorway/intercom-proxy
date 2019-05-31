Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :widgets, :shims, only: :show
  get 'frame.:id', to: 'frames#show', as: :frame
  get 'vendor.:id', to: 'vendors#show', as: :vendor
end

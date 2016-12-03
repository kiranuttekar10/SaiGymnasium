Rails.application.routes.draw do
  resources :fee_details , except: [:new]
  root 'members#index'
  get 'fee_details/new/:id' => 'fee_details#new'
  resources :members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

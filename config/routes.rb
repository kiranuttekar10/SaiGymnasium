Rails.application.routes.draw do
  devise_for :users
 
  root 'members#index'
  #get 'members/pending_fee',to: 'members#pending_fee'
  get 'members/fee_pay/:id' => 'members#fee_pay'
 
  resources :members do
    collection {get :autocomplete}
    collection {get :upcoming_fee}
    collection {get :pending_fee}
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

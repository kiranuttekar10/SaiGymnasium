Rails.application.routes.draw do
  devise_for :users
 
  root 'members#index'
  #get 'members/pending_fee',to: 'members#pending_fee'
  get 'members/fee_pay/:id' => 'members#fee_pay'
  post 'members/fee_pay_regular/:id' => 'members#fee_pay_regular'
  post 'members/fee_pay_new/:id' => 'members#fee_pay_new'
  post 'members/member_reset/:id' => 'members#member_reset'
  get 'members/reset/:id' => 'members#reset',:as => 'member_date_change'
  resources :members do
    collection {get :autocomplete}
    collection {get :upcoming_fee}
    collection {get :pending_fee}
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

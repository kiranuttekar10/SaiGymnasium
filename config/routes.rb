Rails.application.routes.draw do
  devise_for :users , :skip => [:registrations] 
  get '/users/sign_up', to: redirect('/404.html')
  root 'members#index'
  post 'members/update_fee/:id' => 'members#update_fee',:as => 'update_fee'
  
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

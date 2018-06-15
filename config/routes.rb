Rails.application.routes.draw do
  root 'users#test'

  post 'login' => 'users#login'
  get 'weeklist/:user_id' => 'jogs#week_list'
  get 'jogcount/:user_id' => 'jogs#jog_count'
  resources :users, except: %i[new show edit] do
    resources :jogs, except: %i[new show edit]
  end
end

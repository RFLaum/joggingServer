Rails.application.routes.draw do
  root 'users#test'

  post 'test' => 'tests#post_test'

  post 'login' => 'users#login'
  get 'users/:user_id/weeklist' => 'jogs#week_list'
  get 'users/:user_id/weekcount' => 'jogs#week_count'
  get 'users/:user_id/jogpages' => 'jogs#jog_count'
  resources :users, except: %i[new show edit] do
    resources :jogs, except: %i[new show edit]
  end
end

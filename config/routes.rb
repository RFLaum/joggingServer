Rails.application.routes.draw do
  root 'users#test'

  post 'login' => 'users#login'
end

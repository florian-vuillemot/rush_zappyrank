Rails.application.routes.draw do
  get 'user/index'

#  get 'auth/login'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'authorize' => 'auth#gettoken'

  match "/auth/login", to: "auth#login", via: :get
  match "/auth/logout", to: "auth#logout", via: :get
  
  match "/upload", to: "user#upload", via: :post
  match "/ranking", to: "user#ranking", via: :get
  match "/upload", to: "user#upload_get", via: :get
  match "/upload_code", to: "user#upload_code", via: :post
  match "/code", to: "user#live_code", via: :get
  match "/menu", to: "user#menu", via: :get

  root "user#menu"
end

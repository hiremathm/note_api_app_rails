Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :notes do 
  	member do 
  		post "/users/:user_id/authorize-note/", to: "notes#authorize_note"
      get "/users/get_all_collabrators", to: "notes#get_all_collabrators"
  	end 
  end
	  
  post "/users/authenticate", to: "authentication#signin"
  post "/users/signup", to: "authentication#signup"
  get "/users/:id", to: "authentication#show"
  get "/users", to: "authentication#index"
end

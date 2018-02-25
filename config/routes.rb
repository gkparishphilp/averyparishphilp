Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :allowance_admin do 
  	post :update_allowance, on: :member
  end
  resources :allowance


  get "/pictures/in/:cat", to: 'pictures#index'
  get "/pictures/tagged/:tag", to: 'pictures#index'

  resources :pictures
  resources :picture_admin do 
  	get :preview, on: :member
  	delete :empty_trash, on: :collection
  end

  get "/writings/in/:cat", to: 'writings#index'
  get "/writings/tagged/:tag", to: 'writings#index'

  resources :writings
  resources :writing_admin do 
  	get :preview, on: :member
  	delete :empty_trash, on: :collection
  end


  get '/about' => 'swell_media/static#about'

	devise_scope :user do
		get '/login' => 'sessions#new', as: 'login'
		get '/logout' => 'sessions#destroy', as: 'logout'
		get '/register' => 'registrations#new', as: 'register'
	end
	devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions' }




  mount SwellMedia::Engine, :at => '/'
end

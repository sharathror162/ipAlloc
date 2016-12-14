Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  constraints format: :json do
    get '/devices/:address', to: 'devices#get_ip_address', :constraints => { :address => /[0-9.]+/ }

    post '/addresses/assign', to: 'devices#assign_ip_address'
  end 

end

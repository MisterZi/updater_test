Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope 'api', module: 'api' do
    scope 'sync', module: 'sync' do
      get '/users/count' => 'users#count'
    end
  end

end

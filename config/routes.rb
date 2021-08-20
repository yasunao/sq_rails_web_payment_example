Rails.application.routes.draw do
  resources :payments ,except: [:destory, :edit, :update]
  root to: 'payments#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

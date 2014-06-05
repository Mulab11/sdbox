Rails.application.routes.draw do
  resources :contact_items

  get 'contacts/get' => 'contacts#get'

  resources :contacts

  get 'platforms/get' => 'platforms#get'
  get 'platforms/list' => 'platforms#list'

  resources :platforms

  get 'users/login' => 'users#login'
  post 'users/login' => 'users#login'
  get 'users/login_page' => 'users#login_page'
  get 'users/hello' => 'users#hello'
  get 'users/get_all' => 'users#get_all'
  
  resources :users

  get 'receive/test' => 'platform_test#receive'
  get 'bind/test' => 'platform_test#bind'
  
  get 'receive/:id' => 'main#receive'

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

Rails.application.routes.draw do

  
  root 'main#index'

  

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      #post    '/login',    to: 'access#attempt_login'
      #get     '/logout',   to: 'access#logout'
      get     '/check',    to: 'access#check_email'
      #post     '/register',    to: 'access#register'
      #post     '/update',    to: 'access#update'
      #resources :users
    end
  end

  post 'access/attempt_login' => 'access#attempt_login'
  post 'store/add/:id' => 'store#add'
  get 'store' => 'store#index'
  get 'cart' => 'store#cart'
  get 'place' => 'store#place_order'
  get 'clear' => 'store#clear_cart'
  get 'update_quantity' => 'store#update_quantity'
  get 'store/:id' => 'store#show'
  get 'logout' => 'access#logout'
  get 'books/update_categories' => 'books#update_categories'
  get 'books/update_authors/:id' => 'books#update_authors'
  get 'groups/update_previllige' => 'groups#update_previllige'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :users
  resources :books
  resources :categories
  resources :authors
  resources :publishers
  resources :suppliers
  resources :groups
  resources :orders
  #match ':controller(/:action(/:id))', :via => [:get, :post]

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

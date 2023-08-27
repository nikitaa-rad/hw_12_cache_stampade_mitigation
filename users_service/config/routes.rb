Rails.application.routes.draw do
  resources :users do
    collection do
      get :classic_caching
      get :cache_stampede_mitigation
      get :cache_stampede_mitigation_with_flag
    end
  end
end

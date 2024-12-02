Rails.application.routes.draw do
  get "revision" => ->(_) { [ 200, {}, [ File.exist?("built_from_revision") ? File.read("built_from_revision") : ENV.fetch("GIT_COMMIT") ] ] }
  get "boom" => ->(_) { raise "Boom!" }

  # NOTE: If you change anything here, also check JwtAuthentication config in application.rb
  namespace :api do
    resource :build_status, only: :create
    resource :github_actions_webhook, only: :create
    resource :cloud_init, only: :show

    delete "projects/:name" => "projects#destroy"
    resource :build, only: [] do
      collection do
        post :lock
        post :unlock
      end
    end
  end

  # NOTE: If you change anything here, also check JwtAuthentication config in application.rb
  resources :projects
  root to: "projects#index"
end

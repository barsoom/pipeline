Rails.application.routes.draw do
  get "revision" => ->(_) { [ 200, {}, [ File.exist?("built_from_revision") ? File.read("built_from_revision") : ENV.fetch("GIT_COMMIT") ] ] }
  get "boom" => ->(_) { raise "Boom!" }

  namespace :api do
    resource :build_status, only: :create
    delete "projects/:name" => "projects#destroy"
    resource :build, only: [] do
      collection do
        post :lock
        post :unlock
      end
    end
  end

  resources :projects
  root to: "projects#index"
end

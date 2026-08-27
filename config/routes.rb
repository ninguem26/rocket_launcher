Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :space_travel, only: :show, controller: "space_travel" do
    post :add_path_point
    post :calculate
  end

  root "space_travel#show"
end

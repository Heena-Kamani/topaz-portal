Rails.application.routes.draw do
  # What the client sees, through their private link
  get  "q/:token",        to: "shared_quotes#show",   as: :shared_quote
  post "q/:token/accept", to: "shared_quotes#accept", as: :accept_shared_quote

  # The studio side (mine)
  scope "studio" do
    resources :clients, only: %i[index new create]
    resources :quotes do
      member { post :send_to_client }
      resources :line_items, only: %i[create destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "quotes#index"
end

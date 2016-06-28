Rails.application.routes.draw do
  namespace :api do
    post 'webhook/:token' => 'webhooks#create'
  end
end

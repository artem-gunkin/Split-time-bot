Rails.application.routes.draw do
  post 'telegram', to: 'bot#callback'
end

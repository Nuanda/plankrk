Rails.application.routes.draw do

  devise_for :users,
             controllers: {
                omniauth_callbacks: 'users/omniauth_callbacks'
              }

  devise_scope :user do
    delete 'sign_out',
        to: 'devise/sessions#destroy',
        as: :destroy_user_session
  end

  scope '(:locale)', locale: /pl|en/ do
    root 'home#index'

    resources :districts, only: [:show]
    resources :discussions, only: [:index, :show, :create]
  end

end

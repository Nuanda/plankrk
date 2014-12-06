Rails.application.routes.draw do
  devise_for :users,
             controllers: {
                omniauth_callbacks: "users/omniauth_callbacks"
              }

  scope "(:locale)", :locale => /pl|en/ do
    root 'home#index'
  end
end

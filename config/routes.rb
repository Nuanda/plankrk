Rails.application.routes.draw do

  scope "(:locale)", :locale => /pl|en/ do
    root 'home#index'
  end

end

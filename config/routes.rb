Rails.application.routes.draw do

  scope "(:locale)", :locale => /pl|en/ do
    root 'home#index'
    # root :to => 'page#index'
    # get "page/index"
  end

end

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def self.provides_callback_for(provider)
      class_eval %Q{
        def #{provider}
          @user = User.from_omniauth(env["omniauth.auth"])

          if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
          else
            session["devise.#{provider}_data"] = env["omniauth.auth"]
            redirect_to root_url
          end
        end
      }
    end

    [:facebook, :google_oauth2].each do |provider|
      provides_callback_for provider
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
  end
end
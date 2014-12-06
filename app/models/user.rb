class User < ActiveRecord::Base
  devise :rememberable,
         :trackable,
         :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2]

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end
end

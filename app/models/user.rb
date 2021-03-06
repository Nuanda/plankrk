class User < ActiveRecord::Base

  include Nondeletable

  devise :rememberable,
         :trackable,
         :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2]

  has_many :discussions,
           foreign_key: 'author_id'

  has_many :comments,
           foreign_key: 'author_id'

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end

end

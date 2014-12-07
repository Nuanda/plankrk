module AuthenticationHelper
  def sign_in_as(user)
    stub_oauth(
      user.provider.to_sym,
      name: user.name,
      email: user.email
    )
    visit root_path
    find(:linkhref, user_omniauth_authorize_path(user.provider)).click
  end
end
require 'rails_helper'

RSpec.feature 'User authentication' do
  include OauthHelper
  include AuthenticationHelper

  scenario 'existing user signs in using facebook' do
    user = create(:user, provider: :facebook)

    sign_in_as(user)

    expect(page).to have_content user.name
  end

  scenario 'new user signs in using google+' do
    user = build(:user, provider: :google_oauth2)

    sign_in_as(user)

    expect(page).to have_content user.name
  end

  scenario 'user signs out' do
    user = create(:user)

    sign_in_as(user)
    find(:linkhref, '/sign_out?locale=en').click

    expect(page).not_to have_content user.name
  end
end
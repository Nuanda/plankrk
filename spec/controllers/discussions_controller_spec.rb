require 'rails_helper'

RSpec.describe DiscussionsController do
  include Devise::TestHelpers
  include ControllerHelpers

  context '#create' do
    it 'user is able to create new discussion' do
      user = create(:user)
      sign_in(user)
      params = { discussion: { fid: '123', title: 'new discussion' } }

      expect { post :create, params }.
        to change { Discussion.count }.by 1
      expect(response.status).to eq 200
    end

    it 'anonymous cannot create new discussion' do
      params = { discussion: { fid: '123', title: 'new discussion' } }

      expect { post :create, params }.
        to change { Discussion.count }.by 0
      expect(response.status).to eq 401
    end
  end
end

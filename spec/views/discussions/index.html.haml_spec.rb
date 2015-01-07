require 'rails_helper'

RSpec.describe 'discussions/index.html.haml' do
  before do
    allow(controller).
      to receive(:current_ability).
      and_return(ability)
  end

  context 'as anonymous user' do
    let(:ability) { Ability.new(nil) }

    it 'can\'t create new discussion' do
      render

      expect(rendered).
        to_not have_xpath('.//a[@href="#new-discussion"]')
    end
  end

  context 'as logged in user' do
    let(:ability) { Ability.new(create(:user)) }

    it 'can create new discussion' do
      render

      expect(rendered).
        to have_xpath('.//div[@href="#new-discussion"]')
    end
  end
end
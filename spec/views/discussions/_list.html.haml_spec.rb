require 'rails_helper'

RSpec.describe 'discussions/_list.html.haml' do
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
  end

  context 'when no discussions' do
    it 'displays alert' do
      render partial: 'discussions/list.html.haml',
             locals: { list: nil }

      expect(rendered).to have_content 'no ongoing discussions'
    end
  end

  context 'when discussions for fid' do
    it 'displays discussions' do
      discussion = build(:discussion, id: 1)

      render partial: 'discussions/list.html.haml',
             locals: { list: [ discussion ] }

      expect(rendered).to have_content discussion.title
    end

    it 'can delete owned discussion' do
      discussion = create(:discussion, author: user)

      render partial: 'discussions/list.html.haml',
             locals: { list: [ discussion ] }

      path = discussion_path(I18n.locale, discussion)
      expect(rendered).
        to have_xpath(".//a[@href='#{path}']")
    end

    it 'cannot delete not owned discussion' do
      discussion = create(:discussion)

      render partial: 'discussions/list.html.haml',
             locals: { list: [ discussion ] }

      path = discussion_path(I18n.locale, discussion)
      expect(rendered).
        to_not have_xpath(".//a[@href='#{path}']")
    end
  end
end
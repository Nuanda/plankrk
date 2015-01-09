require 'rails_helper'

RSpec.describe 'discussions/recent.html.haml' do
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
  end

  context 'when no discussions' do
    it 'displays alert' do
      render
      expect(rendered).to have_content 'No discussions are present'
    end
  end

  context 'when discussions are present' do
    it 'displays discussions' do
      6.times { create(:discussion) }
      render
      Discussion.recently_created.each do |d|
        expect(rendered).to have_link d.title
      end
    end
  end

  context 'when comments are present' do
    it 'displays discussions with recent comments' do
      %w(a b c d e f).map do |title|
        d = create(:discussion, title: title)
        create(:comment, discussion: d)
      end
      render
      Discussion.recently_commented.each do |d|
        expect(rendered).to have_link d.title
      end
      absent = Discussion.all - Discussion.recently_commented
      expect(rendered).not_to have_link absent.first.title
    end
  end

end

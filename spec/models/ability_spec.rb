require 'rails_helper'

RSpec.describe Ability do
  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }

  it 'author can destroy discussion' do
    owned_discussion = create(:discussion, author: user)
    expect(can?(:destroy, owned_discussion)).to be_truthy
  end

  it 'other user cannot destroy discussion' do
    discussion = create(:discussion)
    expect(can?(:destroy, discussion)).to be_falsy
  end

  it 'logged in user can create new discussion' do
    discussion = build(:discussion, author: user)
    expect(can?(:create, discussion)).to be_truthy
  end

  it 'anonymous is not able to create discussion' do
    ability = Ability.new(nil)
    expect(ability.can?(:create, build(:discussion))).to be_falsy
  end

  def can?(action, subject)
    ability.can?(action, subject)
  end
end

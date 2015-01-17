require 'rails_helper'

RSpec.describe Ability do

  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }

  it 'author can destroy discussion with no comments' do
    owned_discussion = create(:discussion, author: user)
    expect(can?(:destroy, owned_discussion)).to be_truthy
  end

  it 'author cannot destroy discussion with other user comment' do
    owned_discussion = create(:discussion, author: user)
    create(:comment, discussion: owned_discussion)
    create(:comment, author: user, discussion: owned_discussion)
    expect(can?(:destroy, owned_discussion)).to be_falsy
  end

  it 'author can destroy discussion with own comments only' do
    owned_discussion = create(:discussion, author: user)
    create(:comment, author: user, discussion: owned_discussion)
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

  it 'logged in user can post comments' do
    comment = build(:comment, author: user)
    expect(can?(:create, comment)).to be_truthy
  end

  it 'anonymous is not able to post comments' do
    ability = Ability.new(nil)
    expect(ability.can?(:create, build(:comment))).to be_falsy
  end

  def can?(action, subject)
    ability.can?(action, subject)
  end

end

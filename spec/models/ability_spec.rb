require 'rails_helper'

RSpec.describe Ability do
  it 'logged in user can create new discussion' do
    user = create(:user)
    ability = Ability.new(user)
    discussion = build(:discussion, author: user)
    expect(ability.can?(:create, discussion)).to be_truthy
  end

  it 'anonymous is not able to create discussion' do
    ability = Ability.new(nil)
    expect(ability.can?(:create, build(:discussion))).to be_falsy
  end
end

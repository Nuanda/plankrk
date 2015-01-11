require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { should validate_presence_of :author }
  it { should validate_presence_of :discussion }

  describe '#by' do

    it 'returns empty array on nil user' do
      create(:comment)
      expect(Comment.by(nil)).to eq []
      expect(Comment.by(nil)).not_to eq nil
    end

    it 'returns only comments by correct author' do
      u1 = create :user
      u2 = create :user
      create(:comment, content: 'a')
      b = create(:comment, content: 'b', author: u1)
      c = create(:comment, content: 'c', author: u2)
      d = create(:comment, content: 'd', author: u2)
      expect(Comment.count).to eq 4
      expect(Comment.by(u1)).to include b
      expect(Comment.by(u2).count).to eq 2
      expect(Comment.by(u2)).to include c
      expect(Comment.by(u2)).to include d
    end

  end

  # TODO Test for exclusion of Thread circular reference

end

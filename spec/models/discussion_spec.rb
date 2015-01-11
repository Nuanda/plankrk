require 'rails_helper'

RSpec.describe Discussion do

  it { should validate_presence_of :fid }

  describe '#destroy' do

    subject(:d) { create(:discussion) }

    it 'performs comments destroy cascade' do
      c = create(:comment, discussion: d)
      cx = create(:comment)
      expect(Comment.count).to eq 2
      d.destroy
      expect(Discussion.find_by_id(d.id)).to eq nil
      expect(Comment.find_by_id(c.id)).to eq nil
      expect(Comment.find(cx.id)).to eq cx
    end

    it 'is blocked when there are many commenters' do
      create(:comment, discussion: d)
      create(:comment, discussion: d)
      expect(d.comments.count).to eq 2
      expect(d.commenters.count).to eq 2
      d.destroy
      expect(Comment.count).to eq 2
      expect(Discussion.find(d.id)).to eq d
    end

  end

  describe '#commenters' do

    it 'returns empty array when there are no comments' do
      d = create(:discussion)
      expect(d.commenters).to eq []
    end

    it 'does not return the discussion author' do
      a = create(:user)
      d = create(:discussion, author: a)
      create(:comment, discussion: d)
      expect(d.commenters).not_to include a
    end

    it 'returns all commenters only once' do
      c1 = create(:user)
      c2 = create(:user)
      d = create(:discussion)
      create(:comment, discussion: d, author: c1)
      create(:comment, discussion: d, author: c1)
      create(:comment, discussion: d, author: c2)
      expect(d.commenters.count).to eq 2
      expect(d.commenters).to contain_exactly c1, c2
    end

  end

  describe '#about_fid' do

    it 'returns empty array on nil fid' do
      # This is to prevent 500 errors when no fid is passed
      expect(Discussion.about_fid(nil)).to eq []
      expect(Discussion.about_fid(nil)).not_to eq nil
    end

    it 'returns discussions in the newset-first order' do
      a = create(:discussion)
      b = create(:discussion, created_at: Time.now - 10.minutes)
      c = create(:discussion, created_at: Time.now + 5.years)
      result = Discussion.recently_created
      expect(result).to eq [c, a, b]
    end

  end

  describe '#recently_created' do

    it 'returns empty array when no discussions' do
      expect(Discussion.recently_created).to eq []
      expect(Discussion.recently_created).not_to eq nil
    end

    it 'returns only 5 discussions' do
      6.times { create(:discussion) }
      expect(Discussion.recently_created.count).to eq 5
    end

    it 'returns all discussions when there are <=5 in total' do
      3.times { create(:discussion) }
      expect(Discussion.recently_created.count).to eq 3
    end

    it 'returns discussions in the newest-first order' do
      a = create(:discussion)
      b = create(:discussion, created_at: Time.now - 10.minutes)
      c = create(:discussion, created_at: Time.now + 5.years)
      result = Discussion.recently_created
      expect(result).to eq [c, a, b]
    end

  end

  describe '#recently_commented' do

    it 'returns empty array when no discussions' do
      expect(Discussion.recently_commented).to eq []
      expect(Discussion.recently_commented).not_to eq nil
    end

    it 'returns all discussions when there are <=5 in total commented' do
      3.times { create(:comment) }
      expect(Discussion.recently_commented.all.length).to eq 3
    end

    it 'does not return uncommented discussions' do
      2.times { create(:discussion) }
      expect(Discussion.count).to eq 2
      expect(Discussion.recently_commented.all.length).to eq 0
      4.times { create(:comment) }
      expect(Discussion.count).to eq 6
      expect(Discussion.recently_commented.all.length).to eq 4
    end

    it 'does not return duplicate discussions' do
      c1 = create(:comment)
      2.times { create(:comment) }
      3.times { create(:comment, discussion: c1.discussion) }
      expect(Discussion.count).to eq 3
      expect(Comment.count).to eq 6
      expect(Discussion.recently_commented.all.length).to eq 3
    end

    it 'returns only 5 discussions' do
      6.times { create(:comment) }
      expect(Discussion.recently_commented.all.length).to eq 5
    end

    it 'returns discussions in newest comment first order' do
      a,b,c,d,e,f,z =
        %w(a b c d e f z).map{ |x| create(:discussion, title: x) }
      create(:comment, discussion: a)
      create(:comment, discussion: b, created_at: Time.now - 10.minutes)
      create(:comment, discussion: c, created_at: Time.now + 5.years)
      create(:comment, discussion: c, created_at: Time.now - 5.minutes)
      create(:comment, discussion: d, created_at: Time.now - 3.hours)
      create(:comment, discussion: e, created_at: Time.now - 15.minutes)
      create(:comment, discussion: f, created_at: Time.now - 25.minutes)
      expect(Discussion.count).to eq 7
      expect(Comment.count).to eq 7
      result = Discussion.recently_commented
      expect(result.all.length).to eq 5
      expect(result.map(&:title)).to eq %w(c a b e f)
    end

  end

end

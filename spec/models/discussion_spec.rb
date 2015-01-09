require 'rails_helper'

RSpec.describe Discussion do

  it { should validate_presence_of :fid }

  describe '#about_fid' do

    it 'returns empty array on nil fid' do
      # This is to prevent 500 errors when no fid is passed
      expect(Discussion.about_fid(nil)).to eq []
      expect(Discussion.about_fid(nil)).not_to eq nil
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

    it 'returns discussions in newest first order' do
      create(:discussion, title: 'a')
      create(:discussion, title: 'b', created_at: Time.now - 10.minutes)
      create(:discussion, title: 'c', created_at: Time.now + 5.years)
      result = Discussion.recently_created
      expect(result.count).to eq 3
      expect(result[0].title).to eq 'c'
      expect(result[1].title).to eq 'a'
      expect(result[2].title).to eq 'b'
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

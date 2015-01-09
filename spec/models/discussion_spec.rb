require 'rails_helper'

RSpec.describe Discussion do

  it { should validate_presence_of :fid }
  it { should validate_presence_of :author }

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
    pending 'Waiting for :recently_commented to be implemented.'
  end

end

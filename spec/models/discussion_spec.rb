require 'rails_helper'

RSpec.describe Discussion do

  # it { should validate_presence_of :fid }

  describe '#about_fid' do

    it 'returns empty array on nil fid' do
      # This is to prevent 500 errors when no fid is passed
      expect(Discussion.about_fid(nil)).to eq []
      expect(Discussion.about_fid(nil)).not_to eq nil
    end

  end

end

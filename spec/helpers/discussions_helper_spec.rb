require 'rails_helper'

RSpec.describe DiscussionsHelper, type: :helper do

  describe '#time_ago' do

    it 'works ok for time in the future' do
      t = Time.now + 3.minutes
      expect(time_ago(t)).to eq l(t.in_time_zone('CET'), format: :short)
    end

  end

  describe '#discussion_title' do

    it 'throws exception on nil discussion' do
      expect{ discussion_title(nil) }.to raise_error(NoMethodError)
    end

    it 'provides default on nil or empty title' do
      d = create(:discussion, title: nil)
      expect(discussion_title(d)).
        to eq t('discussions.discussion.title.default',
                id: d.id, fid: d.fid
               )
      d = create(:discussion, title: '')
      expect(discussion_title(d)).
        to eq t('discussions.discussion.title.default',
                id: d.id, fid: d.fid
               )
    end

  end

end

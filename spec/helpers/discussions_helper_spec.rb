require 'rails_helper'

RSpec.describe DiscussionsHelper, type: :helper do

  describe '#time_ago' do

    it 'works ok for time in the future' do
      t = Time.now + 3.minutes
      expect(time_ago(t)).to eq l(t, format: :short)
    end

  end

end

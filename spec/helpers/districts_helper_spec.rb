require 'rails_helper'

RSpec.describe DistrictsHelper, type: :helper do

  describe '#mseconds_since_epoch_to_time' do

    it 'returns epoch with nil input' do
      expect(mseconds_since_epoch_to_time(nil)).to eq '01.01.1970'
    end

    it 'returns properly structured date string' do
      expect(mseconds_since_epoch_to_time(1419384324000)).to eq '24.12.2014'
    end

    it 'returns epoch with negative input' do
      expect(mseconds_since_epoch_to_time(-500000)).to eq '01.01.1970'
    end

  end

end

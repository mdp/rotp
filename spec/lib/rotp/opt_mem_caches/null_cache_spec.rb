require 'spec_helper'

module ROTP
  module OptMemCaches
    RSpec.describe NullCache do
      describe '#unused?(_uid, _otp)' do
        it 'returns true' do
          expect(subject.unused?(nil, nil)).to eq(true)
        end
      end
    end
  end
end

require 'spec_helper'
require 'rotp/cli'

RSpec.describe ROTP::CLI do
  let(:cli) { described_class.new('executable', argv).run! }
  let(:now) { Time.utc 2012,1,1 }

  before do
    Timecop.freeze now
  end

  context 'generating a TOTP' do
    let(:argv) { %w(--secret JBSWY3DPEHPK3PXP) }

    it 'prints the corresponding token' do
      expect(cli).to eq '068212'
    end
  end


end

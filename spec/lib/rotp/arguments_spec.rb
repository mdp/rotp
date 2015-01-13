require 'spec_helper'
require 'rotp/arguments'

RSpec.describe ROTP::Arguments do
  let(:arguments) { described_class.new filename, argv }
  let(:argv)      { '' }
  let(:filename)  { 'rotp' }
  let(:options)   { arguments.options }

  context 'without options' do
    describe '#help' do
      it 'shows the help text' do
        expect(arguments.to_s).to include 'Usage: '
      end
    end

    describe '#options' do
      it 'has the default options' do
        expect(options.help).to be_falsey
        expect(options.secret).to be_nil
        expect(options.counter).to eq 0
        expect(options.hmac).to be_falsey
      end
    end
  end

  context 'asking for help' do
    let(:argv) { %w(--help) }

    describe '#options' do
      it 'has the help flag' do
        expect(options.help).to be_truthy
      end
    end
  end

  context 'generating a counter based secret' do
    let(:argv) { %w(--hmac --secret GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ) }

    describe '#options' do
      it 'has the hmac flag' do
        expect(options.hmac).to be_truthy
      end

      it 'knows the secret' do
        expect(options.secret).to eq 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ'
      end
    end
  end

end

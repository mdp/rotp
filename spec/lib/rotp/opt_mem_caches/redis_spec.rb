require 'spec_helper'

module ROTP::OptMemCaches
  RSpec.describe Redis do
    let(:otp) { '354256' }
    let(:uid) { 1 }
    describe '#unused?' do
      context 'when there is no uid' do
        it 'returns true' do
          expect(subject.unused?(nil, nil)).to eq(true)
        end
      end

      context 'when otp is not present in the opt mem cache' do
        let(:dummy_class) { Class.new.send(:include, Console) }
        before do
          allow(subject).to receive(:retrieve).with(uid).and_return(nil)
          allow(subject).to receive(:push).with(uid, otp)
          allow_any_instance_of(RedisMutex).to receive(:lock).and_return(true)
          allow_any_instance_of(RedisMutex).to receive(:unlock).and_return(true)

          @opt_mem_cache_conf_backup = ROTP.config.opt_mem_cache_conf
          ROTP.config.opt_mem_cache_conf[:expiration_time] = 300
        end

        subject { described_class.new }

        after do
          ROTP.config.opt_mem_cache_conf = @opt_mem_cache_conf_backup
        end

        it 'is unused' do
          expect(subject.unused?(uid, otp)).to eq(true)
        end
      end

      context 'when otp is already stored in the opt mem cache' do
        before do
          allow(subject).to receive(:retrieve).with(uid).and_return(otp)
          allow(subject).to receive(:push).with(uid, otp)
          allow_any_instance_of(RedisMutex).to receive(:lock).and_return(true)
          allow_any_instance_of(RedisMutex).to receive(:unlock).and_return(true)
        end

        it 'is used' do
          expect(subject.unused?(uid, otp)).to eq(false)
        end
      end
    end

    describe '#push' do
      let(:redis) { Object.new }
      before do
        allow(subject).to receive(:redis).and_return(redis)
        allow(redis).to receive(:set)
      end
      it 'adds a TTL on otp' do
        expect(redis).to receive(:expire).with(uid, 300)

        subject.send(:push, uid, otp)
      end
    end
  end
end

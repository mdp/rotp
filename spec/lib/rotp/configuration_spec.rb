require 'spec_helper'

module ROTP
  RSpec.describe Configuration do
    describe '#opt_mem_cache' do
      it 'contains default opt mem cache options' do
        expect(subject.opt_mem_cache).to eq(:null_cache)
      end
    end

    describe '#opt_mem_cache_conf' do
      it 'contains default opt mem cache options' do
        expect(subject.opt_mem_cache_conf).to eq({})
      end
    end
  end
end

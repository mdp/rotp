require 'spec_helper'

module ROTP
  RSpec.describe OptMemCaches do
    describe '#camelize' do
      context 'when CamelCase word' do
        it 'does nothing' do
          expect(
            subject.camelize('NullCache')
          ).to eq('NullCache')
        end
      end

      context 'when snake_case' do
        it 'succeeds' do
          expect(
            subject.camelize('null_cache')
          ).to eq('NullCache')
        end
      end

      context 'when snake_case word that contains digits' do
        it 'succeeds' do
          expect(
            subject.camelize('null22_cache56')
          ).to eq('Null22Cache56')
        end
      end

      context 'when namespaced snake_case word' do
        it 'succeeds' do
          expect(
            subject.camelize('rotp/opt_mem_caches/null_cache')
          ).to eq('Rotp::OptMemCaches::NullCache')
        end
      end
    end
  end
end

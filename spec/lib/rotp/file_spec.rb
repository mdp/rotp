require 'spec_helper'
require 'rotp/file'

RSpec.describe ROTP::FILE do
  let(:now) { Time.utc 2012,1,1 }

  before do
    Timecop.freeze now
  end

  context 'Given a file' do
    it 'returns the correct code' do
      file_content = [
        {
          "secret" => "JBSWY3DPEHPK3PXP",
          "label" => "Test label",
          "period" => 30,
          "digits" => 6,
          "algorithm" => "SHA1"
        },
        {
          "secret" => "wrn3pqx5uqxqvnqr",
          "label" => "Test label 2",
          "period" => 30,
          "digits" => 6,
          "algorithm" => "SHA1"
        }
      ].to_json

      allow(File).to receive(:read).and_return(file_content)
      allow(File).to receive(:file?).and_return(true)

      expect(ROTP::FILE.new('file_name').codes).to eq "Test label: 068212\nTest label 2: 408799\n"
    end

    context 'with different settings' do
      it 'returns the correct code' do
        file_content = [
          {
            "secret" => "JBSWY3DPEHPK3PXP",
            "label" => "Test label",
            "period" => 40,
            "digits" => 7,
            "algorithm" => "SHA256"
          }
        ].to_json

        allow(File).to receive(:read).and_return(file_content)
        allow(File).to receive(:file?).and_return(true)

        expect(ROTP::FILE.new('file_name').codes).to eq "Test label: 1200080\n"
      end
    end
  end
end

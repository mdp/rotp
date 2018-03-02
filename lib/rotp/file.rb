module ROTP
  class FILE
    def initialize file
      file = File.file?(file) ? File.read(file) : ''

      begin
        @accounts = JSON.parse(file)
      rescue JSON::ParserError
        @accounts = {}
      end
    end

    def codes
      output = ''
      @accounts.each do |account|
        account_settings = {
          interval: account['period'],
          digits: account['digits'],
          digest: account['algorithm']
        }
        auth_code = ROTP::TOTP.new(account['secret'], account_settings).now

        output += "#{account['label']}: #{auth_code}\n"
      end

      output
    end
  end
end

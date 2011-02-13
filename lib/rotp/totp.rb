module ROTP
  class TOTP < OTP

    attr_reader :interval

    def initialize(s, options = {})
      @interval = options[:interval] || 30
      super
    end

    def at(time)
      unless time.class == Time
        time = Time.at(time.to_i)
      end
      generate_otp(timecode(time))
    end

    def now
      generate_otp(timecode(Time.now))
    end

    # Returns the provisioning URI for the OTP
    # This can then be encoded in a QR Code and used
    # to provision the Google Authenticator app
    # @param [String] name of the account
    # @return [String] provisioning uri
    def provisioning_uri(name)
      "otpauth://totp/#{URI.encode(name)}?secret=#{secret}"
    end

    private

    def timecode(time)
      i = time.utc.to_i * 1000
      i / (interval * 1000)
    end

  end
end

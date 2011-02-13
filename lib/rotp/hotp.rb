module ROTP
  class HOTP < OTP
    def at(count)
      generate_otp(count)
    end

    # Returns the provisioning URI for the OTP
    # This can then be encoded in a QR Code and used
    # to provision the Google Authenticator app
    # @param [String] name of the account
    # @param [Integer] initial counter value, defaults to 0
    # @return [String] provisioning uri
    def provisioning_uri(name, start_count=0)
      "otpauth://hotp/#{URI.encode(name)}?secret=#{secret}&counter=#{start_count}"
    end

  end

end

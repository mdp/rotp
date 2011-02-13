module ROTP
  class HOTP < OTP
    # Generates the OTP for the given count
    # @param [Integer] count counter
    # @returns [Integer] OTP
    def at(count)
      generate_otp(count)
    end

    # Returns the provisioning URI for the OTP
    # This can then be encoded in a QR Code and used
    # to provision the Google Authenticator app
    # @param [String] name of the account
    # @param [Integer] initial_count starting counter value, defaults to 0
    # @return [String] provisioning uri
    def provisioning_uri(name, initial_count=0)
      "otpauth://hotp/#{URI.encode(name)}?secret=#{secret}&counter=#{initial_count}"
    end

  end

end

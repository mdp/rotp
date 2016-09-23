module ROTP
  class HOTP < OTP
    # Generates the OTP for the given count
    # @param [Integer] count counter
    # @returns [Integer] OTP
    def at(count)
      generate_otp(count)
    end

    # Verifies the OTP passed in against the current time OTP
    # @param [String/Integer] otp the OTP to check against
    # @param [Integer] counter the counter of the OTP
    def verify(otp, counter, retries: 0)
      result = nil
      0.upto(retries) do |i|
        current_counter = counter + i
        if super(otp, self.at(current_counter))
          result = current_counter
          break
        end
      end
      return result
    end

    # Returns the provisioning URI for the OTP
    # This can then be encoded in a QR Code and used
    # to provision the Google Authenticator app
    # @param [String] name of the account
    # @param [Integer] initial_count starting counter value, defaults to 0
    # @return [String] provisioning uri
    def provisioning_uri(name, initial_count=0)
      params = {
        secret: secret,
        counter: initial_count,
        digits: digits == DEFAULT_DIGITS ? nil : digits
      }
      encode_params("otpauth://hotp/#{URI.encode(name)}", params)
    end

  end

end

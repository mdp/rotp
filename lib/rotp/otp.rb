module ROTP
  class OTP
    attr_reader :secret, :digits, :digest

    # @param [String] secret in the form of base32
    # @option options digits [Integer] (6)
    #     Number of integers in the OTP
    #     Google Authenticate only supports 6 currently
    # @option options digest [String] (sha1)
    #     Digest used in the HMAC
    #     Google Authenticate only supports 'sha1' currently
    # @returns [OTP] OTP instantiation
    def initialize(s, options = {})
      @digits = options[:digits] || 6
      @digest = options[:digest] || "sha1"
      @secret = s
    end

    # @param [Integer] input the number used seed the HMAC
    # Usually either the counter, or the computed integer
    # based on the Unix timestamp
    def generate_otp(input)
      hmac = OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new(digest),
        byte_secret,
        int_to_bytestring(input)
      )

      offset = hmac[19].ord & 0xf
      code = (hmac[offset].ord & 0x7f) << 24 |
        (hmac[offset + 1].ord & 0xff) << 16 |
        (hmac[offset + 2].ord & 0xff) << 8 |
        (hmac[offset + 3].ord & 0xff)
      code % 10 ** digits
    end

    private

    def verify(input, generated)
      input.to_i == generated
    end

    def byte_secret
      Base32.decode(@secret)
    end

    # Turns an integer to the OATH specified
    # bytestring, which is fed to the HMAC
    # along with the secret
    #
    def int_to_bytestring(int, padding = 8)
      result = []
      until int == 0
        result << (int & 0xFF).chr
        int >>=  8
      end
      result.reverse.join.rjust(padding, 0.chr)
    end

  end
end

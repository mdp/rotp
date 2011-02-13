module ROTP
  class OTP
    attr_reader :secret, :digits, :digest

    # Params: secret in base32
    def initialize(s, options = {})
      @digits = options[:digits] || 6
      @digest = options[:digest] || "sha1"
      @secret = s
    end

    def generate_otp(count)
      hmac = OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new(digest),
        byte_secret,
        int_to_bytestring(count)
      )

      offset = hmac[19] & 0xf
      code = (hmac[offset] & 0x7f) << 24 |
        (hmac[offset + 1] & 0xff) << 16 |
        (hmac[offset + 2] & 0xff) << 8 |
        (hmac[offset + 3] & 0xff)
      code % 10 ** digits
    end

    def byte_secret
      Base32.decode(@secret)
    end

    def int_to_bytestring(int, padding = 8)
      result = []
      until int == 0
        result << (int & 0xFF).chr
        int >>=  8
      end
      result.reverse.join.rjust(8, 0.chr)
    end

  end
end

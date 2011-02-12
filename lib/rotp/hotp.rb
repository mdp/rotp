module ROTP
  class HOTP < OTP
    def at(count)
      generate_otp(count)
    end
  end

end

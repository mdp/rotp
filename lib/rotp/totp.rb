module ROTP
  class TOTP < OTP

    attr_reader :interval

    # @option options [Integer] interval (30) the time interval in seconds for OTP
    #     This defaults to 30 which is standard.
    def initialize(s, options = {})
      @interval = options[:interval] || 30
      super
    end

    # Accepts either a Unix timestamp integer or a Time object.
    # Time objects will be adjusted to UTC automatically
    # @param [Time/Integer] time the time to generate an OTP for
    def at(time)
      unless time.class == Time
        time = Time.at(time.to_i)
      end
      generate_otp(timecode(time))
    end

    # Generate the current time OTP
    # @return [Integer] the OTP as an integer
    def now
      generate_otp(timecode(Time.now))
    end

    # Verifies the OTP passed in against the current time OTP
    # @param [String/Integer] otp the OTP to check against
    def verify(otp, time = Time.now)
      super(otp, self.at(time))
    end

    # Verifies the OTP passed in against the current time OTP
    # and adjacent intervals up to +drift+.
    # @param [String/Integer] otp the OTP to check against
    # @param [Integer] drift the number of seconds that the client
    #     and server are allowed to drift apart
    def verify_with_drift(otp, drift, time = Time.now)
      time = time.to_i
      times = (time-drift..time+drift).step(interval).to_a
      times << time + drift if times.last < time + drift
      times.any? { |ti| verify(otp, ti) }
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
      time.utc.to_i / interval
    end

  end
end

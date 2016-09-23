module ROTP
  DEFAULT_INTERVAL = 30
  class TOTP < OTP

    attr_reader :interval, :issuer

    # @option options [Integer] interval (30) the time interval in seconds for OTP
    #     This defaults to 30 which is standard.
    def initialize(s, options = {})
      @interval = options[:interval] || DEFAULT_INTERVAL
      @issuer = options[:issuer]
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
    def now()
      generate_otp(timecode(Time.now))
    end

    # Verifies the OTP passed in against the current time OTP
    # and adjacent intervals up to +drift+.  Excludes OTPs
    # from `after` and earlier.  Returns time value of
    # matching OTP code for use in subsequent call.
    # @param otp [String] the one time password to verify
    # @param drift [Integer] seconds of drift
    # @param after [Integer] timestamp to exclude
    # @param at [Time] time at which to generate and verify a particular
    #   otp. default Time.now
    # @return [Integer, nil] the last successful timestamp
    #   interval
    def verify(otp, drift: 0, after: nil, at: Time.now)
      drift_start = (at - drift).to_i / interval * interval
      drift_end   = (at + drift).to_i / interval * interval

      times = (drift_start..drift_end).step(interval).to_a
      if after
        times = times.select { |t| t > after }
      end
      times.find { |t|
        super(otp, self.at(t))
      }
    end


    # Returns the provisioning URI for the OTP
    # This can then be encoded in a QR Code and used
    # to provision the Google Authenticator app
    # @param [String] name of the account
    # @return [String] provisioning URI
    def provisioning_uri(name)
      # The format of this URI is documented at:
      # https://github.com/google/google-authenticator/wiki/Key-Uri-Format
      # For compatibility the issuer appears both before that account name and also in the
      # query string.
      issuer_string = issuer.nil? ? "" : "#{URI.encode(issuer)}:"
      params = {
        secret: secret,
        period: interval == 30 ? nil : interval,
        issuer: issuer,
        digits: digits == DEFAULT_DIGITS ? nil : digits,
        algorithm: digest.upcase == 'SHA1' ? nil : digest.upcase,
      }
      encode_params("otpauth://totp/#{issuer_string}#{URI.encode(name)}", params)
    end

    private

    def timecode(time)
      time.utc.to_i / interval
    end

  end
end

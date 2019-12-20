module ROTP
  class HOTP < OTP
    attr_reader :initial_counter

    # @option options [Integer] initial_counter (0) the initial counter for provisioning
    #     This defaults to 30 which is standard.
    def initialize(s, options = {})
      @initial_counter = options[:initial_counter] || 0
      super
    end

    # Generates the OTP for the given count
    # @param [Integer] count counter
    # @returns [Integer] OTP
    def at(count)
      generate_otp(count)
    end

    # Verifies the OTP passed in against the current time OTP
    # @param otp [String/Integer] the OTP to check against
    # @param counter [Integer] the counter of the OTP
    # @param retries [Integer] number of counters to incrementally retry
    def verify(otp, counter, retries: 0)
      counters = (counter..counter + retries).to_a
      counters.find do |c|
        super(otp, at(c))
      end
    end

    # Returns the provisioning URI for the OTP
    # This can then be encoded in a QR Code and used
    # to provision the Google Authenticator app
    # @param [String] name of the account
    # @param [Integer] initial_counter starting counter value, defaults to 0
    # @return [String] provisioning uri
    def provisioning_uri(name=nil, init_counter = 0)
      name = name || @name
      issuer_string = issuer.nil? ? '' : "#{Addressable::URI.escape(issuer)}:"
      params = default_provisioning_params()
      params.merge!({
        counter: init_counter || initial_counter,
      })
      params.merge!(@provisioning_params)
      encode_params("otpauth://hotp/#{issuer_string}#{Addressable::URI.escape(name)}", params)
    end
  end
end

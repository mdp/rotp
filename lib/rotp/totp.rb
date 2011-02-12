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
      generate_otp(timehash(time))
    end

    def now
      generate_otp(timehash(Time.now))
    end

    private

    def timehash(time)
      i = time.utc.to_i * 1000
      i = i / (interval * 1000)
      i
    end

  end
end

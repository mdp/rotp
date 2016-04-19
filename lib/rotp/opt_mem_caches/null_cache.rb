module ROTP
  module OptMemCaches
    class NullCache
      def unused?(_uid, _otp)
        true
      end
    end
  end
end

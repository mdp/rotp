require 'redis'
require 'redis-mutex'

module ROTP
  module OptMemCaches
    class Redis
      attr_reader :redis, :expiration_time

      def initialize
        @redis = ::Redis.new(
          url: ROTP.config.opt_mem_cache_conf[:url],
          db: ROTP.config.opt_mem_cache_conf[:db]
        )
        RedisClassy.redis = @redis
        @expiration_time = ROTP.config.opt_mem_cache_conf[:expiration_time]
      end

      def unused?(uid, otp)
        return true unless uid
        RedisMutex.with_lock("opt_lock_#{uid}", expire: 6, block: 8) do
          unless retrieve(uid) == otp
            push(uid, otp)
            return true
          end
        end
        false
      end

      private

      def retrieve(uid)
        redis.get(uid)
      end

      def push(uid, otp)
        redis.set(uid, otp)
        redis.expire(uid, expiration_time)
      end
    end
  end
end

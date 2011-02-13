require 'rotp/otp'
require 'rotp/hotp'
require 'rotp/totp'
require 'base32'
require 'uri'
require 'openssl'

module ROTP
  BASE32 = 'abcdefghijklmnopqrstuvwxyz234567'
  def self.random_base32(length=16)
    b32 = ''
    OpenSSL::Random.random_bytes(length).each_byte do |b|
      b32 << BASE32[b % 32, 1]
    end
    b32
  end
end

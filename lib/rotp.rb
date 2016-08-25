require 'cgi'
require 'uri'
require 'securerandom'
require 'openssl'
require 'rotp/configuration'
require 'rotp/base32'
require 'rotp/otp'
require 'rotp/hotp'
require 'rotp/totp'
require 'rotp/opt_mem_caches'

module ROTP
  module_function

  attr_accessor :config

  def config
    @config ||= Configuration.new
  end

  def configure
    yield config
  end
end

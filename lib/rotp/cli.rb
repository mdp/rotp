require 'rotp/arguments'
require 'rotp/base32'

module ROTP
  class CLI
    attr_reader :filename, :argv

    def initialize(filename, argv)
      @filename = filename
      @argv = argv
    end

    # :nocov:
    def run
      puts output
    end
    # :nocov:

    def errors
      if requires_secret? && blank_secret?
        return red 'You must also specify a --secret. Try --help for help.'
      end

      if secret_provided?
        if invalid_secret?
          return red 'Secret must be in RFC4648 Base32 format - http://en.wikipedia.org/wiki/Base32#RFC_4648_Base32_alphabet'
        end
        if options.secret.tr('=', '').length < 32
          return red 'Secret must be at least 160 bits (32 characters in Base32)'
        end
      end
    end

    def output
      errors || options.warnings || (help_message if options.mode == :help) || otp_value
    end

    def arguments
      @arguments ||= ROTP::Arguments.new(filename, argv)
    end

    def options
      arguments.options
    end

    def red(string)
      "\033[31m#{string}\033[0m"
    end

    private

    def help_message
      arguments.to_s
    end

    def otp_value
      case options.mode
      when :time
        ROTP::TOTP.new(options.secret, options.to_h).now
      when :hmac
        ROTP::HOTP.new(options.secret, options.to_h).at(options.counter)
      end
    end

    def requires_secret?
      %i[time hmac].include?(options.mode)
    end

    def secret_provided?
      !options.secret.to_s.empty?
    end

    def blank_secret?
      options.secret.to_s.empty?
    end

    def invalid_secret?
      decoded_secret
      false
    rescue ROTP::Base32::Base32Error
      true
    end

    def decoded_secret
      @decoded_secret ||= ROTP::Base32.decode(options.secret)
    end
  end
end

require 'rotp/arguments'

module ROTP
  class CLI

    attr_reader :filename, :argv

    # Convenience wrapper
    def self.run(filename, argv)
      new(filename, argv).run
    end

    def initialize(filename, argv)
      @filename = filename
      @argv = argv
    end

    def run
      puts run!
    end

    def run!
      if options.help
        arguments.to_s

      elsif options.time
        ROTP::TOTP.new(options.secret).now

      elsif options.hmac

      else

      end
    end

    def arguments
      @arguments ||= ROTP::Arguments.new(filename, argv)
    end

    def options
      arguments.options
    end

  end
end

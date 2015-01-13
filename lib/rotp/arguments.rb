require 'optparse'
require 'ostruct'

module ROTP
  class Arguments

    def initialize(filename, arguments)
      @filename = filename
      @arguments = arguments
    end

    def options
      parse
      options!
    end

    def to_s
      parser.help
    end

    private

    attr_reader :arguments, :filename

    def options!
      @options ||= default_options
    end

    def default_options
      OpenStruct.new time: true, counter: 0
    end

    def parse
      parser.parse arguments
    end

    def parser
      OptionParser.new do |parser|
        parser.banner = ''
        parser.separator green('  Usage: ') + bold("#{filename} [options]")
        parser.separator ''
        parser.separator green '  Examples:   '
        parser.separator '    ' + bold("#{filename} --secret p4ssw0rd") + '    # Generates a time-based one-time password'
        parser.separator ''
        parser.separator 'Specific options:'

        parser.on('-s', '--secret [SECRET]', 'The shared secret') do |secret|
          options!.secret = secret
        end

        parser.on('-t', '--time', 'Use time-based OTP according to RFC 6238 (default)') do
          options!.time = true
          options!.hmac = false
        end

        parser.on('-m', '--hmac', 'Use counter-based OTP according to RFC 4226') do
          options!.time = false
          options!.hmac = true
        end


        parser.on_tail('-h', '--help', 'Show this message') do
          options!.help = true
        end

        parser.separator ''
      end
    end

    def bold(string)
      "\033[1m#{string}\033[22m"
    end

    def green(string)
      "\033[32m#{string}\033[0m"
    end

  end
end


require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'uri'
require 'rotp'
require 'timecop'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.color = true
  config.fail_fast = true

  config.before do
    Timecop.return
  end
end

def query_params_for(uri)
  URI.decode_www_form(URI.parse(uri).query).each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |(key, value), params|
    params[key] << value
  end
end

require_relative '../lib/rotp'

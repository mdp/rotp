# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rotp/version"

Gem::Specification.new do |s|
  s.name        = "rotp"
  s.version     = ROTP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["Mark Percival"]
  s.email       = ["mark@markpercival.us"]
  s.homepage    = "http://github.com/mdp/rotp"
  s.summary     = %q{A Ruby library for generating and verifying one time passwords}
  s.description = %q{Works for both HOTP and TOTP, and includes QR Code provisioning}

  s.rubyforge_project = "rotp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('base32', '~> 0.3.2')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  if RUBY_VERSION < "1.9"
    s.add_development_dependency('timecop', "~>0.5.9.2")
  else
    s.add_development_dependency('timecop')
  end
end

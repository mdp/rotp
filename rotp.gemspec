require './lib/rotp/version'

Gem::Specification.new do |s|
  s.name        = 'rotp'
  s.version     = ROTP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['Mark Percival']
  s.email       = ['mark@markpercival.us']
  s.homepage    = 'http://github.com/mdp/rotp'
  s.summary     = 'A Ruby library for generating and verifying one time passwords'
  s.description = 'Works for both HOTP and TOTP, and includes QR Code provisioning'

  s.rubyforge_project = 'rotp'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'addressable', '~> 2.5'

  s.add_development_dependency 'rake', '~> 10.5'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'timecop', '~> 0.8'
end

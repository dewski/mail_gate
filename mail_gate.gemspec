# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mail_gate/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Garrett Bjerkhoel']
  gem.email         = ['me@garrettbjerkhoel.com']
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = 'https://github.com/dewski/mail_gate'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'mail_gate'
  gem.require_paths = ['lib']
  gem.version       = MailGate::VERSION

  gem.add_dependency 'mail', '~> 2.4.1'
end

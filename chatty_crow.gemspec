# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'chatty_crow/version'

Gem::Specification.new do |s|
  s.name        = 'chatty_crow'
  s.version     = ChattyCrow::VERSION.dup
  s.summary     = 'Send your messages to more than 6 comunnication channels.'
  s.license     = 'MIT'
  s.description = 'Library which allows to you easy send messages through chatty crow web service.'

  s.require_paths = %w(lib)
  s.files         = Dir['{generators/**/*,lib/**/*,rails/**/*,script/*}']  +
    %w(chatty_crow.gemspec CHANGELOG Gemfile Guardfile INSTALL LICENSE Rakefile README.textile)
  s.test_files    = Dir.glob('{test}/**/*')

  s.required_ruby_version = '>= 1.9'

  s.add_runtime_dependency('multi_json', '~> 1.0')
  s.add_runtime_dependency('rest-client', '~> 1.7.2')
  s.add_runtime_dependency('mime-types', '>= 1')

  s.add_development_dependency('fakeweb', '~> 1.3')
  s.add_development_dependency('minitest_should', '~> 0.3')
  s.add_development_dependency('json-schema', '~> 2.2')
  s.add_development_dependency('minitest', '~> 4.6')
  s.add_development_dependency('minitest-spec-expect', '~> 0.1')
  s.add_development_dependency('rspec-rails', '~> 2.14')
  s.add_development_dependency('coveralls', '~> 0.7')
  s.add_development_dependency('simplecov', '~> 0.9')

  s.authors = ['Netbrick s.r.o.']
  s.email   = ['support@netbrick.eu', 'info@chattycrow.com']
  s.homepage = 'http://www.chattycrow.com'

  s.platform = Gem::Platform::RUBY
end

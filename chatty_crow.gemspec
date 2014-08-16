# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chatty_crow/version"

Gem::Specification.new do |s|
  s.name        = %q{ChattyCrow}
  s.version     = ChattyCrow::VERSION.dup
  s.summary     = %q{Send your messages to more than 6 comunnication channels to clients.}
  s.license     = %q{MIT}

  s.require_paths = ["lib"]
  s.files         = Dir["{generators/**/*,lib/**/*,rails/**/*,script/*}"]  +
    %w(chatty_crow.gemspec CHANGELOG Gemfile Guardfile INSTALL LICENSE Rakefile README.textile)
  s.test_files    = Dir.glob("{test}/**/*")

  s.add_runtime_dependency("multi_json", "~> 1.10.1")
  s.add_runtime_dependency("rest_client", "~> 1.7.3")

  s.add_development_dependency("fakeweb", "~> 1.3.0")
  s.add_development_dependency("minitest_should", "~> 0.3.1")
  s.add_development_dependency("json-schema", "~> 2.2.4")
  s.add_development_dependency("minitest", "~> 4.6.1")
  s.add_development_dependency('minitest-spec-expect')
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("coveralls")

  s.authors = ["Netbrick s.r.o."]
  s.email   = %q{support@netbrick.eu}
  s.homepage = "http://www.netbrick.eu"

  s.platform = Gem::Platform::RUBY
end

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require 'coveralls/rake/task'

Coveralls::RakeTask.new

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/*.rb'
end

# Default task - test
task default: %w(test coveralls:push)

# Task console
task :console do
  require 'irb'
  require 'irb/completion'
  require './lib/chattycrow'

  ChattyCrow.configure do |config|
    config.host = 'http://localhost:9292/api/v1'
    config.token = '20d8236f-87bd-46a5-9fe9-9c745d25a45b'
    config.default_channel = 'cdb0cb25-237d-403c-a245-949431485fac'
  end

  ARGV.clear
  IRB.start
end

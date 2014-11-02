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
  ARGV.clear
  IRB.start
end

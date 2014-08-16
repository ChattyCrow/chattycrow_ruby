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

#!/usr/bin/env rake
require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

desc 'Run tests'
task :default => :spec

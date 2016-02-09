#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

desc 'Run tests'
task :default => :test

desc 'Run integration tests'
task :integration_tests do
  integration_tests_path = File.expand_path(
    '../test/integration/*_integration_test.rb', __FILE__
  )
  FileList[integration_tests_path].each { |file| require file }
end

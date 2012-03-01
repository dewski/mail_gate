#!/usr/bin/env rake
require 'bundler/gem_tasks'

desc 'Default: run tests'
task :default => :test

desc 'Run MailGate tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

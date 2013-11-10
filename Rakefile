require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'bump/tasks'
require 'wwtd/tasks'
require 'appraisal'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/ie_iframe_cookies_test.rb'
  test.verbose = true
end

task :default => ["appraisal:install", "wwtd"]

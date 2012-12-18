require 'bundler/gem_tasks'
require 'rake/testtask'
require 'bump/tasks'
require 'appraisal'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/ie_iframe_cookies_test.rb'
  test.verbose = true
end

task :default do
  sh "bundle exec rake appraisal:install && bundle exec rake appraisal test"
end

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'bump/tasks'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/ie_iframe_cookies_test.rb'
  test.verbose = true
end

task :default do
  %w[2.3.14 3.1.8 3.2.9].each do |rails_version|
    sh "export RAILS=#{rails_version} && (bundle check || bundle) && bundle exec rake test"
  end
  sh "git checkout Gemfile.lock"
end

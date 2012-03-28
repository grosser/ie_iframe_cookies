require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/ie_iframe_cookies_test.rb'
  test.verbose = true
end

task :default do
  %w[2.3.13 3.0.12 3.1.4 3.2.2].each do |rails_version|
    sh "RAILS=#{rails_version} && (bundle || bundle install) && bundle exec rake test"
  end
  sh "git checkout Gemfile.lock"
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ie_iframe_cookies'
    gem.summary = "Rails: Enabled cookies inside IFrames for IE via p3p headers"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

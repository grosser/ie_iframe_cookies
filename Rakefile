require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/ie_iframe_cookies_test.rb'
  test.verbose = true
end

task :default do
  %w[2.3.14 3.1.5 3.2.5].each do |rails_version|
    sh "export RAILS=#{rails_version} && (bundle check || bundle) && bundle exec rake test"
  end
  sh "git checkout Gemfile.lock"
end

# extracted from https://github.com/grosser/project_template
rule /^version:bump:.*/ do |t|
  sh "git status | grep 'nothing to commit'" # ensure we are not dirty
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  file = 'lib/ie_iframe_cookies/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  version_parts[2] = 0 if index < 2 # remove patch for minor
  version_parts[1] = 0 if index < 1 # remove minor for major
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "bundle && git add #{file} Gemfile.lock && git commit -m 'bump version to #{new_version}'"
end

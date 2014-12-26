name = "ie_iframe_cookies"
require "./lib/#{name}/version"

Gem::Specification.new name, IEIframeCookies::VERSION do |s|
  s.summary = "Rails: Enabled cookies inside IFrames for IE via p3p headers"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib MIT-LICENSE`.split("\n")
  s.license = "MIT"

  s.add_development_dependency 'bump'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-rg'
  s.add_development_dependency 'wwtd'
end

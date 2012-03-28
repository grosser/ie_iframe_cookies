$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "ie_iframe_cookies"
require "#{name}/version"

Gem::Specification.new name, IEIframeCookies::VERSION do |s|
  s.summary = "Rails: Enabled cookies inside IFrames for IE via p3p headers"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end

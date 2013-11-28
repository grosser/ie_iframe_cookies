$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "ie_iframe_cookies"
require "#{name}/version"

Gem::Specification.new name, IEIframeCookies::VERSION do |s|
  s.summary = "Rails: Enabled cookies inside IFrames for IE via p3p headers"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files lib MIT-LICENSE`.split("\n")
  s.license = "MIT"
  cert = File.expand_path("~/.ssh/gem-private-key-grosser.pem")
  if File.exist?(cert)
    s.signing_key = cert
    s.cert_chain = ["gem-public_cert.pem"]
  end

  s.add_development_dependency 'bump'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '~> 4.0'
  s.add_development_dependency 'minitest-rg'
  s.add_development_dependency 'wwtd', '>= 0.3.2'
end

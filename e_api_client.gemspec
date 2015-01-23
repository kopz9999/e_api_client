$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "e_api_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "e_api_client"
  s.version     = EApiClient::VERSION
  s.authors     = ["Kyoto Kopz"]
  s.email       = ["kopz9999@gmail.com"]
  s.homepage    = "http://bitbucket.org/kkyoto/"
  s.summary     = "Simplifies the creation of a Web API Client."
  s.description = "Provides module to simplify the creation of a Web API Client. It makes a perfect fit with 'e_api_server'"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "4.2.0"
  s.add_runtime_dependency 'rest-client', "1.7.2"

  s.add_development_dependency "sqlite3", "1.3.10"
end

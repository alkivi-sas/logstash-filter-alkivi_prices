Gem::Specification.new do |s|
  s.name          = 'logstash-filter-alkivi_prices'
  s.version       = '1.0.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Parse CRD to add cost and prices.'
  s.homepage      = 'https://github.com/alkivi-sas/logstash-filter-alkivi_prices'
  s.authors       = ['Alkivi']
  s.email         = 'anthony@alkivi.fr'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_development_dependency 'logstash-devutils'
end

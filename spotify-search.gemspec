# frozen_string_literal: true

require_relative 'lib/spotify_search/version'

Gem::Specification.new do |spec|
  spec.name          = 'spotify-search'
  spec.version       = SpotifySearch::VERSION
  spec.authors       = ['Grant Ammons']
  spec.email         = ['grant@grant.dev']

  spec.summary       = 'Search spotify using the web api'
  spec.description   = 'Search spotify using the web api'
  spec.homepage      = 'https://github.com/gammons/spotify-search'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.1')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gammons/spotify-search'
  spec.metadata['changelog_uri'] = 'https://github.com/gammons/spotify-search/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'http', '~> 5.0'
  spec.add_development_dependency 'dotenv'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

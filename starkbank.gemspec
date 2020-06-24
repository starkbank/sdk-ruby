# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'starkbank'
  s.version = '0.4.2'
  s.date = '2020-04-06'
  s.summary = 'SDK to facilitate Ruby integrations with Stark Bank'
  s.authors = 'starkbank'
  s.homepage = 'https://github.com/starkbank/sdk-ruby'
  s.files = Dir['lib/**/*.rb']
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.3'
  s.add_dependency('starkbank-ecdsa', '~> 0.0.5')
  s.add_development_dependency('minitest', '~> 5.14.1')
  s.add_development_dependency('rake', '~> 13.0')
  s.add_development_dependency('rubocop', '~> 0.81')
end

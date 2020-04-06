Gem::Specification.new do |s|
  s.name = 'starkbank'
  s.version = '2.0.0'
  s.date = '2020-04-06'
  s.summary = 'SDK to facilitate Ruby integrations with Stark Bank'
  s.authors = 'starkbank'
  s.homepage = 'https://github.com/starkbank/sdk-ruby'
  s.files = Dir['lib/**/*.rb']
  s.licenses = 'MIT'
  s.required_ruby_version = '>= 2.3'
  s.add_dependency('starkbank-ecdsa', '~> 0.0.2')
  s.add_development_dependency('rspec', '~> 3.0')
end

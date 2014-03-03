#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'war-pack'
  s.version = '0.1.0'

  s.summary = 'pack you rack application as warfile'
  s.description = <<-END
END

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']
  s.homepage = 'https://github.com/mkristian/war-pack'

  s.bindir = "bin"
  s.executables = ['war-pack']

  s.license = 'MIT'

  s.files += Dir['lib/**/*.rb']
  s.files += Dir['MIT-LICENSE']
  s.files += Dir['*.md']
  s.files += Dir['Gemfile*']

  s.add_runtime_dependency "ruby-maven", "~> 3.1.1"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "thor", "~> 0.18.0"
  s.add_development_dependency "minitest", "~> 4.0"
end

Gem::Specification.new do |s|
  s.name = 'chikka'
  s.version = '0.1.6'
  s.date = '2015-02-13'
  s.summary = 'A ruby interface to the Chikka SMS API'
  s.authors = ["Andrei Navarro"]
  s.email = 'andrei@eggsapps.com'
  s.files = ["lib/chikka.rb"]
  s.homepage = 'https://github.com/scrambledeggs/chikka'
  s.license = 'MIT'

  s.add_development_dependency('rake','>= 10.4.2')
  s.add_development_dependency('webmock', '~> 1.20.4')
end
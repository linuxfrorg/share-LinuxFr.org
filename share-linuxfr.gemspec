require "./lib/share-linuxfr/version.rb"

Gem::Specification.new do |s|
  s.name             = "share-linuxfr"
  s.version          = ShareLinuxFr::VERSION
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "http://github.com/nono/share-LinuxFr.org"
  s.authors          = "Bruno Michel"
  s.email            = "nono@linuxfr.org"
  s.description      = "Share the publication of news on social networks"
  s.summary          = "When a news is published on LinuxFr.org, share the link on twitter, identi.ca and google buzz"
  s.extra_rdoc_files = %w(README.md)
  s.files            = Dir["LICENSE", "README.md", "Gemfile", "bin/*", "lib/**/*.rb", "config/*"]
  s.executables      = ["share-linuxfr"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.add_dependency "daemons", "~>1.1"
  s.add_dependency "em-hiredis", "~>0.1"
  s.add_dependency "em-http-request", "~>1.0"
  s.add_dependency "yajl-ruby", "~>0.8"
  s.add_dependency "simple_oauth", "~>0.1"
end

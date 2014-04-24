require "./lib/share-linuxfr/version.rb"

Gem::Specification.new do |s|
  s.name             = "share-linuxfr"
  s.version          = ShareLinuxFr::VERSION
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "https://github.com/linuxfrorg/share-LinuxFr.org"
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
  s.add_dependency "redis", "~>2.2"
  s.add_dependency "yajl-ruby", "~>1.1"
  s.add_dependency "twitter", "~>4.0"
end

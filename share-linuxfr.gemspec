require "./lib/share-linuxfr/version.rb"

Gem::Specification.new do |s|
  s.name             = "share-linuxfr"
  s.version          = ShareLinuxFr::VERSION
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "https://github.com/linuxfrorg/share-LinuxFr.org"
  s.authors          = ["Benoît Sibaud", "Bruno Michel"]
  s.email            = "team@linuxfr.org"
  s.description      = "Share the publication of news on social networks"
  s.summary          = "When a news is published on LinuxFr.org, share the link on twitter/X and bsky, and maybe others again one day"
  s.licenses         = ['AGPL-3.0-only']
  s.extra_rdoc_files = %w(README.md)
  s.files            = Dir["LICENSE", "README.md", "Gemfile", "bin/*", "lib/**/*.rb", "config/*"]
  s.executables      = ["share-linuxfr"]
  s.require_paths    = ["lib"]
  s.add_dependency "daemons", "~>1.4"
  s.add_dependency "redis", "4.4.0"
  s.add_dependency "yajl-ruby", "~>1.4"
  s.add_dependency "twitter", "~>8.0"
  s.add_dependency "bskyrb", "~> 0.5.3"
  s.add_dependency "optparse", "~> 0.3"
end

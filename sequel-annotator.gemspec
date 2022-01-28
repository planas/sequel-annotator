# frozen_string_literal: true

require_relative "lib/sequel/annotator/version"

Gem::Specification.new do |spec|
  spec.name    = "sequel-annotator"
  spec.version = Sequel::Annotator::VERSION
  spec.authors = ["Adrià Planas"]
  spec.email   = ["adriaplanas@edgecodeworks.com"]

  spec.summary     = "Annotate your Sequel models."
  spec.description = "Utility class to generate and inject table-formatted schema information from Sequel models."
  spec.homepage    = "https://github.com/planas/sequel-annotator"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata = {
    "homepage_uri"    => "https://github.com/planas/sequel-annotator",
    "source_code_uri" => "https://github.com/planas/sequel-annotator/tree/v#{spec.version}",
    "changelog_uri"   => "https://github.com/planas/sequel-annotator/releases/tag/v#{spec.version}"
  }

  spec.files         = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]
  spec.bindir        = "exe"
  spec.executables   = []

  spec.add_dependency "sequel"
  spec.add_dependency "terminal-table", "~> 3.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.4"
end

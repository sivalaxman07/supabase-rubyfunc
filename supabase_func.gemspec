# frozen_string_literal: true

require_relative "lib/supabase_func/version"

Gem::Specification.new do |spec|
  spec.name = "supafunc"
  spec.version = SupabaseFunc::VERSION
  spec.authors = ["sivalaxman07"]
  spec.email = ["mylapillisivalaxman@gmail.com"]

  spec.summary = "Ruby Client library to interact with Supabase Functions."
  spec.description = "Ruby Client library to interact with Supabase Functions."
  spec.homepage = "https://github.com/sivalaxman07/supabase-rubyfunc"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "https://github.com/sivalaxman07/supabase-rubyfunc"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sivalaxman07/supabase-rubyfunc"
  spec.metadata["changelog_uri"] = "https://github.com/sivalaxman07/supabase-rubyfunc/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "httparty"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

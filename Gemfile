source 'https://rubygems.org'

group :development do
  gem 'rake', '~> 10.4'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rescue', '~> 1.3'
  gem 'pry-stack_explorer', '~> 0.4'
end

group :test do
  gem 'foodcritic', '~> 4.0'
  gem 'chefspec', '~> 4.2'
  gem 'ci_reporter_rspec', '~> 1.0'
  gem 'test-kitchen', '~> 1.4'
  gem 'kitchen-vagrant', '~> 0.16'
  gem 'berkshelf', '~> 3.2'
  gem 'guard', '~> 2.12'
  gem 'guard-rspec', '~> 4.5'
  gem 'guard-foodcritic', '~> 1.1'
  gem 'guard-rake', '~> 0.0'
  gem 'rubocop', '~> 0.28.0'
  gem 'guard-rubocop', '~> 1.1'
  gem 'ruby_gntp', '~> 0.3'
  gem 'chef-vault', '~> 2.5'
  gem 'aws-sdk', '~> 2.0'
  gem 'chef-vault-testfixtures', '~> 0.4'
end

# load local overrides
gemfile_dir = File.absolute_path(File.join('.', 'lib', 'gemfile'))
Dir.glob(File.join(gemfile_dir, '*.bundler')).each do |snippet|
  # rubocop:disable Lint/Eval
  eval File.read(snippet), nil, snippet
end

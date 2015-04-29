source 'https://rubygems.org'

group :development do
  gem 'rake', '~> 10.3'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rescue', '~> 1.3'
  gem 'pry-stack_explorer', '~> 0.4'
end

group :test do
  gem 'foodcritic', '~> 4.0'
  gem 'chefspec', '~> 4.1'
  gem 'ci_reporter_rspec', '~> 1.0'
  gem 'test-kitchen', '~> 1.2'
  gem 'kitchen-vagrant', '~> 0.15'
  # log_switch v1.0.0 breaks tailor v1.4.0 but tailor
  # does a >= pin; we add a ~> pin for now to keep us
  # on the 0.4.x release
  gem 'log_switch', '~> 0.4'
  gem 'tailor', '~> 1.4'
  # use our forked version until
  # https://github.com/berkshelf/berkshelf/pull/1393 has been accepted
  gem 'berkshelf', '~> 3.2',
    git: 'https://github.com/Nordstrom/berkshelf.git',
    branch: 'use_httpclient_instead_of_nethttp'
  # use our forked version until
  # https://github.com/berkshelf/berkshelf-api-client/pull/5 has been accepted
  gem 'berkshelf-api-client', '~> 1.2',
    git: 'https://github.com/Nordstrom/berkshelf-api-client.git',
    branch: 'use_httpclient_instead_of_nethttp'
  # pin to 2.8 series until guard-foodcritic has been updated for v2 API
  gem 'guard', '~> 2.8.2'
  # pin to 4.3 series until guard-foodcritic has been updated for v2 API
  gem 'guard-rspec', '~> 4.3.1'
  gem 'guard-foodcritic', '~> 1.0'
  gem 'guard-rake', '~> 0.0'
  gem 'rubocop', '~> 0.28.0'
  gem 'guard-rubocop', '~> 1.1'
  gem 'ruby_gntp', '~> 0.3'
end

# load local overrides
gemfile_dir = File.absolute_path(File.join('.', 'lib', 'gemfile'))
Dir.glob(File.join(gemfile_dir, '*.bundler')).each do |snippet|
  # rubocop:disable Lint/Eval
  eval File.read(snippet), nil, snippet
end

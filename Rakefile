require 'foodcritic'
require 'foodcritic/rake_task'
require 'tailor/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'kitchen/rake_tasks'

# Style tests (Foodcritic / Tailor)
FoodCritic::Rake::LintTask.new
Tailor::RakeTask.new do |t|
  {
    spec:        'spec/recipes/*_spec.rb',
    spec_helper: 'spec/spec_helper.rb',
    attributes:  'attributes/*.rb',
    resources:   'resources/*.rb',
    providers:   'providers/*.rb',
    libraries:   'libraries/**/*.rb',
    recipes:     'recipes/*.rb',
    metadata:    'metadata.rb'
  }.each do |name, glob|
    t.file_set glob, name do |s|
      s.max_line_length 1000
      s.max_code_lines_in_method 1000
      s.max_code_lines_in_class 1000
    end
  end
end

RuboCop::RakeTask.new do |t|
  t.formatters = ['progress']
  t.options = ['-D']
  t.patterns = %w(
    attributes/*.rb
    recipes/*.rb
    libraries/**/*.rb
    resources/*.rb
    providers/*.rb
    spec/**/*.rb
    test/**/*.rb
    ./metadata.rb
    ./Berksfile
    ./Gemfile
    ./Rakefile
  )
end

desc 'Run Style Tests'
task style: [:foodcritic, :tailor, :rubocop]

# ChefSpec (RSpec)
RSpec::Core::RakeTask.new

desc 'Generate ChefSpec coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:spec].invoke
end

# Test Kitchen
begin
  Kitchen::RakeTasks.new
rescue LoadError
  puts 'test-kitchen initialization failed; disabling kitchen tasks'
end

# if we are running inside the CI pipeline, turn on
# xUnit-style test reports
if ENV.key?('CI_BUILD')
  require 'ci/reporter/rake/rspec'
  task spec: 'ci:setup:rspec'
end

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
if Rails.env.development? || Rails.env.test?
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'
  require 'coveralls/rake/task'

  Coveralls::RakeTask.new
  RSpec::Core::RakeTask.new(:spec)
  task test_with_coveralls: [:spec, :cucumber]
end
Rails.application.load_tasks

task default: 'brakeman:run'
task default: 'bundler:audit'



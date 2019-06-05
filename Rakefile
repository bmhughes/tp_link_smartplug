# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: 'test'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

task test: %w[rubocop spec]

task build: %w[rubocop spec] do
  sh "gem build 'tp_link_smartplug.gemspec'"
end

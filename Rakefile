# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'

task default: 'spec'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  # t.rcov = true
end

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: 'build'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

desc 'Run linting and spec tests'
task test: %w(rubocop spec)

desc 'Build gem file'
task build: %w(rubocop spec) do
  sh "gem build 'tp_link_smartplug.gemspec'"
end

desc 'Start irb with ./lib included'
task :console do
  exec 'irb -r tp_link_smartplug -I ./lib'
end

desc 'Clean build/test artifacts'
task :clean do
  sh 'rm -f *.gem'
  sh 'rm -rf coverage'
  sh 'rm -f spec/examples.txt'
  sh 'rm -rf pkg'
end

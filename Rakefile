require "rubygems"

full_name = "Lullizio IRC bot"
package_name = "lullizio"
version = "0.1"

require "rake/clean"

require "rake/testtask"
desc "Run tests"
Rake::TestTask.new do |t|
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
  t.warning = true
end

task :default => :test


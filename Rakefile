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

desc "Search unfinished parts of source code"
task :todo do
  FileList["**/*.rb"].egrep /#.*(TODO|FIXME)/
end

task :default => :test


gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

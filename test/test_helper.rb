require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'minitest/rails'
require 'mocha/mini_test'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  extend MiniTest::Spec::DSL
  # Add more helper methods to be used by all tests here...
end

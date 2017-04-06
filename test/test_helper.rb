ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

require 'support/authentication'
require 'support/json_service'
require 'support/serialization'
require 'support/serialization/jsonapi'

class ActiveSupport::TestCase
  include Serialization::Assertions

  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Authentication::OAuth::Helpers
  include JSONService::Helpers
  include Serialization::ControllerAssertions
end

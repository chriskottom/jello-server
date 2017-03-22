require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
  end

  test 'User.admin includes all administrators' do
    assert_equal [ @admin ], User.admin
  end
end

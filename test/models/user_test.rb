require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @user = users(:user1)
  end

  test 'User.admin includes all administrators' do
    assert_equal [ @admin ], User.admin
  end

  test 'User.authenticate! can successfully authenticate any User' do
    assert_equal @admin, User.authenticate!(@admin.email, 'secret')
    assert_equal @user, User.authenticate!(@user.email, 'secret')
  end

  test 'User.authenticate! returns false with bad credentials' do
    refute User.authenticate!(@admin.email, '!secret')
    refute User.authenticate!('non-user@example.com', 'secret')
  end

  test 'User.authenticate_admin! can authenticate any admin' do
    assert_equal @admin, User.authenticate_admin!(@admin.email, 'secret')
  end

  test 'User.authenticate_admin! will not authenticate an admin with bad credentials' do
    refute User.authenticate_admin!(@admin.email, '!secret')
  end

  test 'User.authenticate_admin! will not authenticate a non-admin' do
    refute User.authenticate_admin!(@user.email, 'secret')
  end
end

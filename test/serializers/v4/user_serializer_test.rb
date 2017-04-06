require 'test_helper'

class V4::UserSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Serialization::JSONAPI::Assertions
  include Serialization::JSONAPI::Helpers

  setup do
    @user = users(:admin)
  end

  test 'identifies the User' do
    assert_equal @user.id.to_s, serialized_user.dig(:data, :id)
    assert_equal 'users', serialized_user.dig(:data, :type)
  end

  test 'serializes all visible attributes for a User' do
    assert_equal @user.email, serialized_user_attributes[:email]
    assert_equal @user.gravatar_url, serialized_user_attributes[:'gravatar-url']
    assert_equal @user.admin?, serialized_user_attributes[:admin]
    assert_equal @user.created_at, serialized_user_attributes[:"created-at"]
    assert_equal @user.updated_at, serialized_user_attributes[:"updated-at"]
  end

  test 'includes links for the User' do
    assert_equal 1, serialized_user_links.count

    self_link = { self: v4_user_url(@user) }
    assert_equal self_link, serialized_user_links
  end

  test 'includes currently active Boards created by the User' do
    create_user_boards(3)
    active_boards = serialized_user_relationships.dig(:'active-boards', :data)

    assert_equal 4, active_boards.count

    expected_ids = @user.boards.where(archived: false).pluck(:id)
    assert_ids expected_ids, active_boards
  end

  test 'includes archived Boards created by the User' do
    create_user_boards(5)
    inactive_boards = serialized_user_relationships.dig(:'archived-boards', :data)

    assert_equal 5, inactive_boards.count

    expected_ids = @user.boards.where(archived: true).pluck(:id)
    assert_ids expected_ids, inactive_boards
  end

  private

  def create_user_boards(count = 5)
    (1..count).each do |n|
      @user.boards.create(title: "Active Board #{ n }")
      @user.boards.create(title: "Inactive Board #{ n }", archived: true)
    end
  end

  def serialized_user(user = nil)
    user ||= @user
    @_serialized_user ||= serialized_data(user, V4::UserSerializer)
  end

  def serialized_user_attributes(user = nil)
    jsonapi_attributes serialized_user(user)
  end

  def serialized_user_links(user = nil)
    jsonapi_links serialized_user(user)
  end

  def serialized_user_relationships(user = nil)
    jsonapi_relationships serialized_user(user)
  end

  def serialized_user_includes(user = nil)
    jsonapi_includes serialized_user(user)
  end
end

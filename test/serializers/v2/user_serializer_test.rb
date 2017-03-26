require 'test_helper'

class V2::UserSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Serialization::Helpers

  setup do
    @user = users(:admin)
  end

  test 'serializes all visible attributes for a User' do
    %i(id email gravatar_url admin created_at updated_at).each do |attribute|
      assert_equal @user.send(attribute), serialized_user[attribute]
    end
  end

  test 'includes links for the User' do
    assert_equal 2, serialized_user[:links].count

    self_link = { rel: :self, href: v2_user_url(@user) }
    assert_link self_link, serialized_user

    boards_link = { rel: :boards, href: v2_user_boards_url(@user) }
    assert_link boards_link, serialized_user
  end

  test 'includes currently active Boards created by the User' do
    create_user_boards(3)
    active_boards = serialized_user[:active_boards]

    assert_equal 4, active_boards.count

    expected_ids = @user.boards.where(archived: false).pluck(:id)
    assert_ids expected_ids, active_boards

    assert_keys %i(id title links), active_boards.first
  end

  test 'includes archived Boards created by the User' do
    create_user_boards(5)
    inactive_boards = serialized_user[:archived_boards]

    assert_equal 5, inactive_boards.count

    expected_ids = @user.boards.where(archived: true).pluck(:id)
    assert_ids expected_ids, inactive_boards

    assert_keys %i(id title links), inactive_boards.first
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
    serialized_data(user, V2::UserSerializer)
  end
end

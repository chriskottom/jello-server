require 'test_helper'

class UserSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:admin)
  end

  test 'serializes all visible attributes for a User' do
    %i(id email gravatar_url admin created_at updated_at).each do |attribute|
      assert_equal @user.send(attribute), serialized_user[attribute]
    end
  end

  test 'includes links for the User' do
    serialized_links = serialized_user[:links]
    assert_equal 2, serialized_links.count

    self_url = serialized_links.find { |url| url[:rel] == :self }
    refute_nil self_url
    assert_equal user_url(@user), self_url[:href]

    boards_url = serialized_links.find { |url| url[:rel] == :boards }
    refute_nil boards_url
    assert_equal user_boards_url(@user), boards_url[:href]
  end

  test 'includes currently active Boards created by the User' do
    create_user_boards(3)
    active_boards = serialized_user[:active_boards]
    active_ids = active_boards.map { |board| board[:id] }.sort

    assert_equal 4, active_ids.count

    expected_ids = @user.boards.where(archived: false).pluck(:id).sort
    assert_equal expected_ids, active_ids

    board = active_boards.first
    assert_equal %i(id links title), board.keys.sort
  end

  test 'includes archived Boards created by the User' do
    create_user_boards(5)
    inactive_boards = serialized_user[:archived_boards]
    inactive_ids = inactive_boards.map { |board| board[:id] }.sort

    assert_equal 5, inactive_ids.count

    expected_ids = @user.boards.where(archived: true).pluck(:id).sort
    assert_equal expected_ids, inactive_ids

    board = inactive_boards.first
    assert_equal %i(id links title), board.keys.sort
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
    UserSerializer.new(user).as_json
  end
end

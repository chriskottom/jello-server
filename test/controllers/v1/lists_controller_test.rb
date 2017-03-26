require 'test_helper'

class V1::ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:active)
    @board = boards(:active)
    @user = users(:admin)
    @list_attributes = {
      board_id: @board.id,
      creator_id: @user.id,
      title: 'Another List',
      archived: false
    }
  end

  test "should get index" do
    get v1_lists_url, as: :json
    assert_response :success
  end

  test "should create list" do
    assert_difference('List.count') do
      post v1_lists_url, params: { list: @list_attributes }, as: :json
    end

    assert_response 201
  end

  test "should show list" do
    get v1_list_url(@list), as: :json
    assert_response :success
  end

  test "should update list" do
    patch v1_list_url(@list), params: { list: @list_attributes }, as: :json
    assert_response 200
  end

  test "should destroy list" do
    assert_difference('List.count', -1) do
      delete v1_list_url(@list), as: :json
    end

    assert_response 204
  end
end

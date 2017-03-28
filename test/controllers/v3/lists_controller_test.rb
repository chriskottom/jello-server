require 'test_helper'

class V3::ListsControllerTest < ActionDispatch::IntegrationTest
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
    get v3_lists_url, headers: auth_headers, as: :json
    assert_response :success
  end

  test "should create list" do
    assert_difference('List.count') do
      post v3_lists_url,
           headers: auth_headers,
           params: { list: @list_attributes },
           as: :json
    end

    assert_response 201
  end

  test "should show list" do
    get v3_list_url(@list), headers: auth_headers, as: :json
    assert_response :success
  end

  test "should update list" do
    patch v3_list_url(@list),
          headers: auth_headers,
          params: { list: @list_attributes },
          as: :json
    assert_response 200
  end

  test "should destroy list" do
    assert_difference('List.count', -1) do
      delete v3_list_url(@list), headers: auth_headers, as: :json
    end

    assert_response 204
  end
end

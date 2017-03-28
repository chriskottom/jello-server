require 'test_helper'

class V3::BoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @board = boards(:active)
    @user = users(:admin)
    @board_attributes = {
      creator_id: @user.id,
      title: 'Another Board',
      archived: false
    }
  end

  test "should get index" do
    get v3_boards_url, headers: auth_headers, as: :json
    assert_response :success
  end

  test "should create board" do
    assert_difference('Board.count') do
      post v3_boards_url,
           headers: auth_headers,
           params: { board: @board_attributes },
           as: :json
    end

    assert_response 201
  end

  test "should show board" do
    get v3_board_url(@board), headers: auth_headers, as: :json
    assert_response :success
  end

  test "should update board" do
    patch v3_board_url(@board),
          headers: auth_headers,
          params: { board: @board_attributes },
          as: :json
    assert_response 200
  end

  test "should destroy board" do
    assert_difference('Board.count', -1) do
      delete v3_board_url(@board), headers: auth_headers, as: :json
    end

    assert_response 204
  end
end

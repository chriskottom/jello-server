require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:one)
  end

  test "should get index" do
    get lists_url, as: :json
    assert_response :success
  end

  test "should create list" do
    assert_difference('List.count') do
      post lists_url, params: { list: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show list" do
    get list_url(@list), as: :json
    assert_response :success
  end

  test "should update list" do
    patch list_url(@list), params: { list: {  } }, as: :json
    assert_response 200
  end

  test "should destroy list" do
    assert_difference('List.count', -1) do
      delete list_url(@list), as: :json
    end

    assert_response 204
  end
end

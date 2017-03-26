require 'test_helper'

class V1::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card = cards(:active)
    @list = lists(:active)
    @user = users(:admin)
    @card_attributes = {
      list_id: @list.id,
      creator_id: @user.id,
      assignee_id: @user.id,
      title: 'Another Card',
      description: 'This is a card.',
      archived: false
    }
  end

  test "should get index" do
    get v1_cards_url, as: :json
    assert_response :success
  end

  test "should create card" do
    assert_difference('Card.count') do
      post v1_cards_url, params: { card: @card_attributes }, as: :json
    end

    assert_response 201
  end

  test "should show card" do
    get v1_card_url(@card), as: :json
    assert_response :success
  end

  test "should update card" do
    patch v1_card_url(@card), params: { card: @card_attributes }, as: :json
    assert_response 200
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete v1_card_url(@card), as: :json
    end

    assert_response 204
  end
end

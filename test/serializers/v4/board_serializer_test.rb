require 'test_helper'

class V4::BoardSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Serialization::JSONAPI::Helpers

  setup do
    @board = boards(:active)
  end

  test 'identifies the Board' do
    assert_equal @board.id.to_s, serialized_board.dig(:data, :id)
    assert_equal 'boards', serialized_board.dig(:data, :type)
  end

  test 'serializes all attributes for a Board' do
    assert_equal @board.title, serialized_board_attributes[:title]
    assert_equal @board.archived?, serialized_board_attributes[:archived]
    assert_equal @board.created_at, serialized_board_attributes[:"created-at"]
    assert_equal @board.updated_at, serialized_board_attributes[:"updated-at"]
  end

  test 'includes links for the Board' do
    assert_equal 1, serialized_board_links.count

    self_link = { self: v4_board_url(@board) }
    assert_equal self_link, serialized_board_links
  end

  test 'includes the creator of the Board' do
    serialized_creator = serialized_board_relationships[:creator]

    assert_equal @board.creator.id.to_s,
                 serialized_creator.dig(:data, :id)
    assert_equal 'users', serialized_creator.dig(:data, :type)
    assert_equal v4_user_url(@board.creator),
                 serialized_creator.dig(:links, :related)
  end

  private

  def serialized_board
    @_serialized_board ||= serialized_data(@board, V4::BoardSerializer)
  end

  def serialized_board_attributes
    serialized_board.dig(:data, :attributes)
  end

  def serialized_board_links
    serialized_board.dig(:data, :links)
  end

  def serialized_board_relationships
    serialized_board.dig(:data, :relationships)
  end
end

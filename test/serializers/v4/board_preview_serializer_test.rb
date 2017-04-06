require 'test_helper'

class V4::BoardPreviewSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Serialization::JSONAPI::Helpers

  setup do
    @board = boards(:active)
  end

  test 'identifies the Board' do
    assert_equal @board.id.to_s, serialized_board.dig(:data, :id)
    assert_equal 'board', serialized_board.dig(:data, :type)
  end

  test 'serializes the basic attributes for a Board' do
    assert_equal @board.title, serialized_board_attributes[:title]
    assert_equal @board.archived?, serialized_board_attributes[:archived]
  end

  test 'includes the link back to the Board' do
    assert_equal 1, serialized_board_links.count

    self_link = { self: v4_board_url(@board) }
    assert_equal self_link, serialized_board_links
  end

  private

  def serialized_board
    @_serialized_board ||= serialized_data(@board, V4::BoardPreviewSerializer)
  end

  def serialized_board_attributes
    serialized_board.dig(:data, :attributes)
  end

  def serialized_board_links
    serialized_board.dig(:data, :links)
  end
end

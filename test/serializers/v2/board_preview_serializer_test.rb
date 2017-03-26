require 'test_helper'

class V2::BoardPreviewSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Serialization::Helpers

  setup do
    @board = boards(:active)
  end

  test 'serializes the basic attributes for a Board' do
    %i(id title).each do |attribute|
      assert_equal @board.send(attribute), serialized_board[attribute]
    end
  end

  test 'includes the link back to the Board' do
    assert_equal 1, serialized_board[:links].count

    self_link = { rel: :self, href: v2_board_url(@board) }
    assert_link self_link, serialized_board
  end

  private

  def serialized_board
    serialized_data(@board, V2::BoardPreviewSerializer)
  end
end

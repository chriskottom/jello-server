require 'test_helper'

class V2::BoardSerializerTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Serialization::Helpers

  setup do
    @board = boards(:active)
  end

  test 'serializes all attributes for a Board' do
    %i(id title archived created_at updated_at).each do |attribute|
      assert_equal @board.send(attribute), serialized_board[attribute]
    end
  end

  test 'includes links for the Board' do
    assert_equal 2, serialized_board[:links].count

    self_link = { rel: :self, href: v2_board_url(@board) }
    assert_link self_link, serialized_board

    creator_link = { rel: :creator, href: v2_user_url(@board.creator) }
    assert_link creator_link, serialized_board
  end

  test 'includes the creator of the Board' do
    creator = serialized_board[:creator]
    assert_equal @board.creator.id, creator[:id]
  end

  private

  def serialized_board
    serialized_data(@board, V2::BoardSerializer)
  end
end

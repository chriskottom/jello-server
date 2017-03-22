class BoardPreviewSerializer < ApplicationSerializer
  type :board

  attributes :id, :title, :links

  def links
    [
      link(:self, board_url(object))
    ]
  end
end

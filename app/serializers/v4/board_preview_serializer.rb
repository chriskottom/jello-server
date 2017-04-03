class V4::BoardPreviewSerializer < V4::BaseSerializer
  type :board

  attributes :id, :title, :links

  def links
    [
      link(:self, v4_board_url(object))
    ]
  end
end

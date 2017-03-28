class V3::BoardPreviewSerializer < V3::BaseSerializer
  type :board

  attributes :id, :title, :links

  def links
    [
      link(:self, v3_board_url(object))
    ]
  end
end

class V1::BoardPreviewSerializer < V1::BaseSerializer
  type :board

  attributes :id, :title, :links

  def links
    [
      link(:self, v1_board_url(object))
    ]
  end
end

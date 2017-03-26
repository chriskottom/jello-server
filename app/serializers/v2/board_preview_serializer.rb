class V2::BoardPreviewSerializer < V2::BaseSerializer
  type :board

  attributes :id, :title, :links

  def links
    [
      link(:self, v2_board_url(object))
    ]
  end
end

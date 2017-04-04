class V4::BoardPreviewSerializer < V4::BaseSerializer
  type :board

  attributes :id, :title, :archived

  link(:self) { v4_board_url(object) }
end

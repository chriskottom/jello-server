class V3::BoardSerializer < V3::BaseSerializer
  attributes :id, :title, :archived, :created_at, :updated_at, :links

  belongs_to :creator, serializer: V3::UserSerializer

  def links
    [
      link(:self, v3_board_url(object)),
      link(:creator, v3_user_url(object.creator))
    ]
  end
end

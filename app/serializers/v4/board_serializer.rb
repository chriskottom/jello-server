class V4::BoardSerializer < V4::BaseSerializer
  attributes :id, :title, :archived, :created_at, :updated_at, :links

  belongs_to :creator, serializer: V4::UserSerializer

  def links
    [
      link(:self, v4_board_url(object)),
      link(:creator, v4_user_url(object.creator))
    ]
  end
end

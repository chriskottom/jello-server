class V1::BoardSerializer < V1::BaseSerializer
  attributes :id, :title, :archived, :created_at, :updated_at, :links

  belongs_to :creator, serializer: V1::UserSerializer

  def links
    [
      link(:self, v1_board_url(object)),
      link(:creator, v1_user_url(object.creator))
    ]
  end
end

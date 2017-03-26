class V2::BoardSerializer < V2::BaseSerializer
  attributes :id, :title, :archived, :created_at, :updated_at, :links

  belongs_to :creator, serializer: V2::UserSerializer

  def links
    [
      link(:self, v2_board_url(object)),
      link(:creator, v2_user_url(object.creator))
    ]
  end
end

class V4::BoardSerializer < V4::BaseSerializer
  attributes :id, :title, :archived, :created_at, :updated_at

  belongs_to :creator, serializer: V4::UserSerializer do
    link(:related) { v4_user_url(object.creator) }
    object.creator
  end

  link(:self) { v4_board_url(object) }
end

class BoardSerializer < ApplicationSerializer
  attributes :id, :title, :archived, :created_at, :updated_at, :links

  belongs_to :creator, serializer: UserSerializer

  def links
    [
      link(:self, board_url(object)),
      link(:creator, user_url(object.creator))
    ]
  end
end

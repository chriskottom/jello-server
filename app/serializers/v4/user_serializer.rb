class V4::UserSerializer < V4::BaseSerializer
  attributes :id, :email, :gravatar_url, :admin, :created_at, :updated_at, :links

  has_many :active_boards, serializer: V4::BoardPreviewSerializer do
    object.boards.where(archived: false)
  end
  has_many :archived_boards, serializer: V4::BoardPreviewSerializer do
    object.boards.where(archived: true)
  end

  def links
    [
      link(:self, v4_user_url(object)),
      link(:boards, v4_user_boards_url(object))
    ]
  end
end

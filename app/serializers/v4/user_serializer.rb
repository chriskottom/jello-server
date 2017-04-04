class V4::UserSerializer < V4::BaseSerializer
  attributes :id, :email, :gravatar_url, :admin, :created_at, :updated_at

  has_many :boards, serializer: V4::BoardPreviewSerializer do
    link(:relative) { v4_user_boards_url(object) }
    object.boards
  end

  has_many :active_boards, serializer: V4::BoardPreviewSerializer do
    object.boards.where(archived: false)
  end

  has_many :archived_boards, serializer: V4::BoardPreviewSerializer do
    object.boards.where(archived: true)
  end

  link(:self) { v4_user_url(object) }
end

class UserSerializer < ApplicationSerializer
  attributes :id, :email, :gravatar_url, :admin, :created_at, :updated_at, :links

  has_many :active_boards, serializer: BoardPreviewSerializer do
    object.boards.where(archived: false)
  end
  has_many :archived_boards, serializer: BoardPreviewSerializer do
    object.boards.where(archived: true)
  end

  def links
    [
      link(:self, user_url(object)),
      link(:boards, user_boards_url(object))
    ]
  end
end

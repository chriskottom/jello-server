class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :gravatar_url, :admin, :created_at, :updated_at, :links

  def link(rel, href)
    { rel: rel, href: href }
  end

  def links
    [
      link(:self, user_url(object)),
      link(:boards, user_boards_url(object))
    ]
  end
end

class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def link(rel, href)
    { rel: rel, href: href }
  end
end

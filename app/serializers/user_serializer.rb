class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :gravatar_url, :admin, :created_at, :updated_at
end

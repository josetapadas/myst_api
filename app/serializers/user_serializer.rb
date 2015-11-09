class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :authentication_token, :updated_at, :created_at
end

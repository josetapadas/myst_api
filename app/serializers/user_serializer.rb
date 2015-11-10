class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :authentication_token, :updated_at, :created_at
end

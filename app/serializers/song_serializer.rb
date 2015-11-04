class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at, :created_at
end

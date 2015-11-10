class SongTrackSerializer < ActiveModel::Serializer
  attributes :id, :name, :song_id, :user_id, :updated_at, :created_at
end

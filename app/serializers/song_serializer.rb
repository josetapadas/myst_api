class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id, :song_track_ids, :updated_at, :created_at
end

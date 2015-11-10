class SongTrack < ActiveRecord::Base
  validates :name, presence: true
  validates :song_id, :user_id, presence: true

  belongs_to :song
  belongs_to :user
end

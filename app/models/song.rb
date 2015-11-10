class Song < ActiveRecord::Base
  include ActiveModel::Serialization

  validates :title, presence: true, uniqueness: true
  validates :title, :user_id, presence: true

  belongs_to :user
  has_many :song_tracks
end

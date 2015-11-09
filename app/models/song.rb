class Song < ActiveRecord::Base
  include ActiveModel::Serialization

  validates :title, presence: true, uniqueness: true
  validates :title, :user_id, presence: true

  belongs_to :user
end

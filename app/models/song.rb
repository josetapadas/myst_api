class Song < ActiveRecord::Base
  include ActiveModel::Serialization

  validates :title, presence: true, uniqueness: true
end

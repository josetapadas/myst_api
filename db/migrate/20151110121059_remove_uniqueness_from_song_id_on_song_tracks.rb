class RemoveUniquenessFromSongIdOnSongTracks < ActiveRecord::Migration
  def change
    remove_index :song_tracks, :song_id
    add_index :song_tracks, :song_id
  end
end

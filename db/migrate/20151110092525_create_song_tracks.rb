class CreateSongTracks < ActiveRecord::Migration
  def change
    create_table :song_tracks do |t|
      t.string :name, null: false, default: ''
      t.integer :song_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :song_tracks, :song_id, unique: true
    add_index :song_tracks, :user_id
  end
end

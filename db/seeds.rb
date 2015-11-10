require 'ffaker'

User.destroy_all
Song.destroy_all
SongTrack.destroy_all

5.times do |i|
  User.create(email: "#{i}-#{FFaker::Internet.email}", password: 'le_password', password_confirmation: 'le_password')
end

User.create(email: "admin@myst.com", password: 'le_password', password_confirmation: 'le_password', role: 'admin')

10.times do |i|
  s = Song.new(title: FFaker::HipsterIpsum.phrase, user: User.all.sample)
  s.save

  5.times do
    s.song_tracks << SongTrack.create(name: FFaker::HipsterIpsum.phrase, user: User.all.sample, song: s)
  end
end

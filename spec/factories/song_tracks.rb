FactoryGirl.define do
  factory :song_track do
    name { FFaker::HipsterIpsum.phrase }
    user
    song
  end
end

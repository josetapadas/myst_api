require 'rails_helper'
require 'spec_helper'

describe SongTrack do
  it "has a valid factory" do
    expect(FactoryGirl.create(:song_track)).to be_valid
  end
end

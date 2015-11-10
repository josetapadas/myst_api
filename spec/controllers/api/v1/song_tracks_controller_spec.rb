require 'rails_helper'

describe Api::V1::SongTracksController, type: :controller do
  describe "#create" do
    context "successfully creates a song" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @user)
        @song_track_params = FactoryGirl.attributes_for(:song_track)
        request.headers['Authorization'] =  @user.authentication_token
        post(:create, { user_id: @user.id, song_id: @song.id, song_track: @song_track_params.merge(user_id: @user.id) })
      end

      it "should return the created SongTrack" do
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:song_track][:name]).to eq(@song_track_params[:name])
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @song = FactoryGirl.create(:song, user: @user)
      @song_track = FactoryGirl.create(:song_track, user: @user, song: @song)
      request.headers['Authorization'] =  @user.authentication_token
    end

    it "should update the song successfully" do
      patch(:update, { user_id: @user.id, song_id: @song.id, id: @song_track.id, song_track: { name: "Lead Guitar", user_id: @user.id } })
      reply = JSON.parse(response.body, symbolize_names: true)

      expect(reply[:song_track][:name]).to eq("Lead Guitar")
      expect(response.status).to eq(200)
    end

    it "should not update a song with invalid parameters" do
      patch(:update, { user_id: @user.id, song_id: @song.id, id: @song_track.id, song_track: { name: "", user_id: @user.id } })
      reply = JSON.parse(response.body, symbolize_names: true)

      expect(reply[:errors][:name]).to include("can't be blank")
      expect(response.status).to eq(422)
    end

    it "should not allow another user to update a song" do
      request.headers['Authorization'] =  "lollertoken"

      patch(:update, { user_id: '10', song_id: @song.id, id: @song_track.id, song_track: { name: "Hammer Drums", user_id: '10' } })
      reply = JSON.parse(response.body, symbolize_names: true)

      expect(reply[:errors]).to be_eql("Not authenticated")
      expect(response.status).to eq(401)
    end

    describe "#destroy" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @user)
        @song_track = FactoryGirl.create(:song_track, user: @user, song: @song)
        request.headers['Authorization'] =  @user.authentication_token
      end

      it "should allow a user to delete a song" do
        delete(:destroy, { user_id: @user.id, song_id: @song.id, id: @song_track.id })
      end

      it "should not allow another user to delete a song" do
        request.headers['Authorization'] =  "lollertoken"

        delete(:destroy, { user_id: '10', song_id: @song.id, id: @song_track.id })

        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors]).to be_eql("Not authenticated")
        expect(response.status).to eq(401)
      end
    end
  end
end

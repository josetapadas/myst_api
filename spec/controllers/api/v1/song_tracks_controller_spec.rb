require 'rails_helper'

describe Api::V1::SongTracksController, type: :controller do
  describe "#create" do
    context "successfully creates a song" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @user)
        @song_track_params = FactoryGirl.attributes_for(:song_track)
        request.headers['Authorization'] =  @user.authentication_token
        post(:create, { song_track: @song_track_params.merge(user_id: @user.id, song_id: @song.id) })
      end

      it "should return the created SongTrack" do
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:song_track][:name]).to eq(@song_track_params[:name])
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#update" do
    context "Regular User" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @user)
        @song_track = FactoryGirl.create(:song_track, user: @user, song: @song)
        request.headers['Authorization'] =  @user.authentication_token
      end

      it "should update the song successfully" do
        patch(:update, { id: @song_track.id, song_track: { name: "Lead Guitar", user_id: @user.id } })
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:song_track][:name]).to eq("Lead Guitar")
        expect(response.status).to eq(200)
      end

      it "should not update a song with invalid parameters" do
        patch(:update, { id: @song_track.id, song_track: { name: "", user_id: @user.id } })
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors][:name]).to include("can't be blank")
        expect(response.status).to eq(422)
      end

      it "should not allow another user to update a song" do
        request.headers['Authorization'] =  "lollertoken"

        patch(:update, { id: @song_track.id, song_track: { name: "Hammer Drums", user_id: '10' } })
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors]).to be_eql("Not authenticated")
        expect(response.status).to eq(401)
      end
    end

    context "Admin User" do
      before(:each) do
        @regular_user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @regular_user)
        @song_track = FactoryGirl.create(:song_track, user: @regular_user)
        @admin_user = FactoryGirl.create(:user, role: 'admin')
        request.headers['Authorization'] =  @admin_user.authentication_token
      end

      it "should be able to update any record as an Admin" do
        patch(:update, { id: @song_track.id, song_track: { name: "Cello", song_id: @song.id } })
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:song_track][:name]).to eq("Cello")
        expect(response.status).to eq(200)
      end

      it "should not be able to update any non owned record" do
        @yet_another_regular_user = FactoryGirl.create(:user)
        request.headers['Authorization'] =  @yet_another_regular_user.authentication_token
        patch(:update, { id: @song_track.id, song_track: { name: "Cello", song_id: @song.id } })
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors]).to be_eql("Access Denied")
        expect(response.status).to eq(401)
      end
    end

    describe "#destroy" do
      before(:each) do
        @regular_user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @regular_user)
        @song_track = FactoryGirl.create(:song_track, user: @regular_user)
        @admin_user = FactoryGirl.create(:user, role: 'admin')
        request.headers['Authorization'] =  @admin_user.authentication_token
      end

      it "should allow a user to delete a song" do
        delete(:destroy, { id: @song_track.id })
      end

      it "should not allow another user to delete a song" do
        request.headers['Authorization'] =  "lollertoken"

        delete(:destroy, { id: @song_track.id })

        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors]).to be_eql("Not authenticated")
        expect(response.status).to eq(401)
      end
    end
  end
end

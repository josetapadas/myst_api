require 'rails_helper'

describe Api::V1::SongsController, type: :controller do
  describe "#create" do
    context "successfully creates a song" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @song_params = FactoryGirl.attributes_for(:song)
        request.headers['Authorization'] =  @user.authentication_token

        post(:create, { user_id: @user.id, song: @song_params })
      end

      it "should return the created Song" do
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:song][:title]).to eq(@song_params[:title])
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @song = FactoryGirl.create(:song, user: @user)
      request.headers['Authorization'] =  @user.authentication_token
    end

    it "should update the song successfully" do
      patch(:update, { user_id: @user.id, id: @song.id, song: { title: "Echoes" } })
      reply = JSON.parse(response.body, symbolize_names: true)
      expect(reply[:song][:title]).to eq("Echoes")
      expect(response.status).to eq(200)
    end

    it "should not update a song with invalid parameters" do
      patch(:update, { user_id: @user.id, id: @song.id, song: { title: "" } })
      reply = JSON.parse(response.body, symbolize_names: true)

      expect(reply[:errors][:title]).to include("can't be blank")
      expect(response.status).to eq(422)
    end

    it "should not allow another user to update a song" do
      request.headers['Authorization'] =  "lollertoken"

      patch(:update, { user_id: '10', id: @song.id, song: { title: "Never gonna give you up" } })
      reply = JSON.parse(response.body, symbolize_names: true)

      expect(reply[:errors]).to be_eql("Not authenticated")
      expect(response.status).to eq(401)
    end

    describe "#destroy" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song, user: @user)
        request.headers['Authorization'] =  @user.authentication_token
      end

      it "should allow a user to delete a song" do
        delete(:destroy, { user_id: @user.id, id: @song.id })
      end

      it "should not allow another user to delete a song" do
        request.headers['Authorization'] =  "lollertoken"

        delete(:destroy, { user_id: '10', id: @song.id })

        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors]).to be_eql("Not authenticated")
        expect(response.status).to eq(401)
      end
    end
  end
end

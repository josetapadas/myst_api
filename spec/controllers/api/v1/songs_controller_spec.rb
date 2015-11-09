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
end

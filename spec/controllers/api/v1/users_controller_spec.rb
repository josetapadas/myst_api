require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before :each do
    request.headers["Accept"] = "application/myst.1"
  end

  describe "#show" do
    before :each do
      @user = FactoryGirl.create(:user)
      get(:show, id: @user.id, format: :json)
    end

    it 'should return the user information' do
      reply = JSON.parse(response.body, symbolize_names: true)
      expect(reply[:user][:email]).to eql(@user.email)
    end
  end
end

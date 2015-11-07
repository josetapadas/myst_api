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

  describe "#create" do
    context "successfully creating users" do
      before(:each) do
        @user_params = FactoryGirl.attributes_for(:user)
        post(:create, { user: @user_params }, format: :json)
      end

        it "should return the created user" do
          reply = JSON.parse(response.body, symbolize_names: true)
          expect(reply[:user][:email]).to(eql @user_params[:email])
      end
    end

    context "errors while creating users" do
      before(:each) do
        missing_params = { password: "le_password", password_confirmation: "le_password" }
        post(:create, { user: missing_params }, format: :json)
      end

      it "should return an erroneus message" do
        reply = JSON.parse(response.body, symbolize_names: true)
        expect(reply[:errors][:email]).to include("can't be blank")
      end
    end
  end
end

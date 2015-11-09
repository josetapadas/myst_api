require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do
  describe "#create" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    context "successful login" do
      before(:each) do
        credentials = { email: @user.email, password: @user.password }
        post(:create, { session: credentials })
      end

      it "should return the authenticated user and token" do
        reply = JSON.parse(response.body, symbolize_names: true)

        puts reply

        expect(reply[:user][:authentication_token]).to eql(@user.authentication_token)
        expect(response.status).to eq(200)
      end
    end

    context "unsuccessful login" do
      before(:each) do
        credentials = { email: @user.email, password: "this_is_not_the_password_you_are_looking_for" }
        post(:create, { session: credentials })
      end

      it "returns a json with an error" do
        reply = JSON.parse(response.body, symbolize_names: true)

        expect(reply[:errors]).to eql("Invalid email or password")
        expect(response.status).to eq(422)
      end
    end
  end
end

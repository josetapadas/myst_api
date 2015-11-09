require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  context "#generate_authentication_token" do
    it "generates an authentication token" do
      Devise.stub(:friendly_token).and_return("not_so_friendly_t0k3n")

       @user = FactoryGirl.create(:user)

      expect(@user.authentication_token).to eql("not_so_friendly_t0k3n")
    end
  end
end

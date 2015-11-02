require 'rails_helper'
require 'spec_helper'

describe Song do
  it "has a valid factory" do
    expect(FactoryGirl.create(:song)).to be_valid
  end
end

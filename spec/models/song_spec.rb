require 'rails_helper'
require 'spec_helper'

describe Song do
  let!(:echoes) { FactoryGirl.create(:song, title: 'Echoes') }

  it "has a valid factory" do
    expect(FactoryGirl.create(:song)).to be_valid
  end

  it "has uniqueness on title" do
    expect { FactoryGirl.create(:song, title: 'Echoes') }.to raise_error ActiveRecord::RecordInvalid
  end
end

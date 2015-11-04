FactoryGirl.define do
  factory :song do
    title { FFaker::HipsterIpsum.phrase }
  end
end

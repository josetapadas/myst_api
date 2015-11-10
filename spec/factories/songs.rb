FactoryGirl.define do
  factory :song do
    title { FFaker::HipsterIpsum.phrase }
    user
  end
end

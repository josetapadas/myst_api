FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'lollerpassword'
    password_confirmation 'lollerpassword'
  end
end

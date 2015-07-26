FactoryGirl.define do
  factory :user do
    name 'Alexander'
    email 'email@mail.com'
    provider 'facebook'
    avatar 'avatar_url'
    sequence(:oauth_token) { |n| "123asd123#{n}" }
    chat_password '12345678'
    token { SecureRandom.urlsafe_base64(nil, false) }
  end
end




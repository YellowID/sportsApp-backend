FactoryGirl.define do
  factory :user do
    name 'Alexander'
    email 'email@mail.com'
    provider 'facebook'
    oauth_token '123asd123'
    chat_password '12345678'
  end
end




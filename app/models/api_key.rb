class ApiKey < ActiveRecord::Base
  def self.generate!
    access_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless exists?(access_token: random_token)
    end

    create!(access_token: access_token)
  end
end

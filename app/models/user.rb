class User < ActiveRecord::Base
  validates :oauth_token, :provider, presence: true

  has_many :games

  def chat_password=(unhashed_password)
    write_attribute(:chat_password, encryptor.encrypt_and_sign(unhashed_password))
  end

  def chat_password
    encryptor.decrypt_and_verify(read_attribute(:chat_password))
  end

  private

  def encryptor
    @encryptor ||= ActiveSupport::MessageEncryptor.new(Rails.configuration.secret_key_base)
  end
end

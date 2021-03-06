class User < ActiveRecord::Base
  validates :provider_id, :provider, presence: true

  has_many :games
  has_many :user_sport_type_settings
  has_many :sport_types, through: :user_sport_type_settings

  has_many :game_members
  has_many :participate_games, -> { where("state = ? OR state = ?", :confirmed, :possible) }, through: :game_members, source: :game
  has_many :rejected_games, -> { where("state = ? OR state = ?", :rejected, :nil) }, through: :game_members, source: :game
  has_many :my_games, through: :game_members, source: :game

  def sport_setting(sport_type)
    user_sport_type_settings.find_by(sport_type: sport_type)
  end

  def chat_password=(unhashed_password)
    write_attribute(:chat_password, encryptor.encrypt_and_sign(unhashed_password))
  end

  def chat_password
    encryptor.decrypt_and_verify(read_attribute(:chat_password))
  end

  def generate_token!
    access_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end

    update!(token: access_token)
  end

  private

  def encryptor
    @encryptor ||= ActiveSupport::MessageEncryptor.new(Rails.configuration.secret_key_base)
  end
end

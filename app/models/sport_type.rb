class SportType < ActiveRecord::Base
  validates :name, presence: true

  has_many :games
  has_many :user_sport_type_settings
  has_many :users, through: :user_sport_type_settings
end

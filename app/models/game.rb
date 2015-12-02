class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :sport_type
  has_many :game_members
  has_many :members, through: :game_members, source: :user
  has_many :confirmed_members, -> { where("state = ? OR state = ?", :confirmed, :possible) }, through: :game_members, source: :user

  validates :user, :sport_type, :age, :start_at, :level,
    :numbers, :title, :latitude, :longitude, presence: true

  scope :actual, -> { where('start_at > ?', Time.now.utc) }

  def state(user_id)
    game_members.select { |game_member| game_member.user_id ==  user_id }.first.try(:state)
  end
end

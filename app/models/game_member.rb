class GameMember < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  after_initialize :set_initial_status

  state_machine :state, initial: :possible do
    event :to_confirmed do
      transition all => :confirmed
    end

    event :to_rejected do
      transition all => :rejected
    end

    event :to_possible do
      transition all => :possible
    end
  end

  private

  def set_initial_status
    self.state ||= :possible
  end
end

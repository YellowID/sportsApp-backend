class GameMember < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  state_machine :state, initial: nil do
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
end

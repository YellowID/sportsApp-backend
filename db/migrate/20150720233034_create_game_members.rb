class CreateGameMembers < ActiveRecord::Migration
  def change
    create_table :game_members, id: false do |t|
      t.references :user
      t.references :game
    end

    add_index :game_members, [:game_id, :user_id], unique: true
  end
end

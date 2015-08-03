class AddStateToGameMembers < ActiveRecord::Migration
  def change
    add_column :game_members, :id, :primary_key
    add_column :game_members, :state, :string
  end
end

class AddNoteToGames < ActiveRecord::Migration
  def change
    add_column :games, :note, :string
  end
end

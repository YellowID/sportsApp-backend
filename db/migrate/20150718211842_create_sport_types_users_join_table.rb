class CreateSportTypesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :user_sport_type_settings do |t|
      t.references :sport_type
      t.references :user
      t.integer :level, default: 1
    end

    add_index :user_sport_type_settings, [:sport_type_id, :user_id], unique: true
  end
end

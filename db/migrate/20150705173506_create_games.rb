class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :user, index: true
      t.references :sport_type, index: true
      t.datetime :start_at
      t.integer :age
      t.integer :numbers
      t.integer :level

      t.timestamps
    end
  end
end

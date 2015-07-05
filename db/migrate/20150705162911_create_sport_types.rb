class CreateSportTypes < ActiveRecord::Migration
  def change
    create_table :sport_types do |t|
      t.string :name
    end
  end
end

class AddLocationFieldsToGames < ActiveRecord::Migration
  def change
    add_column :games, :title, :string
    add_column :games, :country, :string
    add_column :games, :city, :string
    add_column :games, :address, :string
    add_column :games, :latitude, :decimal, precision: 15, scale: 10
    add_column :games, :longitude, :decimal, precision: 15, scale: 10
  end
end

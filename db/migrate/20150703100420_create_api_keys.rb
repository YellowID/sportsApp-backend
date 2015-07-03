class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token

      t.timestamp
    end

     add_index :api_keys, :access_token
  end
end

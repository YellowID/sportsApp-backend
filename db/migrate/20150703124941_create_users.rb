class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.string :oauth_token
      t.string :chat_password
    end

    add_index :users, [:provider, :oauth_token], unique: true
  end
end

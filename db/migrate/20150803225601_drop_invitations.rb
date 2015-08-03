class DropInvitations < ActiveRecord::Migration
  def up
    drop_table :invitations
  end

  def down
    create_table :invitations do |t|
      t.references :user, index: true
      t.references :game, index: true
      t.references :owner, index: true
      t.boolean :confirmed, default: false

      t.timestamps
    end
  end
end

class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :organization, index:true, foreign_key: true, null: false
      t.integer :sender_id, null: false
      t.integer :recipient_id
      t.string :email, null: false
      t.string :token, null: false
      t.boolean :accepted, null: false, default: false

      t.timestamps
    end
  end
end

class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :network, index: true, foreign_key: true, null: false
      t.string :network_user_id, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :authentications, [:user_id, :network_id], unique: true
  end
end

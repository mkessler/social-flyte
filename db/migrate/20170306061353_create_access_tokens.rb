class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.references :network, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.string :network_user_id, null: false
      t.string :token, null: false
      t.string :secret
      t.datetime :expires_at

      t.timestamps
    end

    add_index :access_tokens, [:user_id, :network_id], unique: true
  end
end

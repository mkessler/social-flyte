class CreateFacebookTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_tokens do |t|
      t.references :user, foreign_key: true, null: false
      t.string :encrypted_token, null: false
      t.string :encrypted_token_iv, null: false
      t.string :network_user_id, null: false
      t.string :network_user_name
      t.string :network_user_image_url
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :facebook_tokens, [:user_id, :network_user_id], unique: true
  end
end

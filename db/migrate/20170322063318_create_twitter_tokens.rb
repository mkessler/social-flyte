class CreateTwitterTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_tokens do |t|
      t.references :organization, foreign_key: true, null: false
      t.string :encrypted_token, null: false
      t.string :encrypted_secret, null: false
      t.string :encrypted_token_iv, null: false
      t.string :encrypted_secret_iv, null: false
      t.string :network_user_id, null: false
      t.string :network_user_name, null: false
      t.string :network_user_image_url, null: false

      t.timestamps
    end

    add_index :twitter_tokens, [:organization_id, :network_user_id], unique: true
  end
end

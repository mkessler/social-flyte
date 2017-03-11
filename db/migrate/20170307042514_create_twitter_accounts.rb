class CreateTwitterAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_accounts do |t|
      t.references :organization, foreign_key: true, null: false
      t.string :twitter_id, null: false
      t.string :encrypted_token, null: false
      t.string :encrypted_secret, null: false
      t.string :encrypted_token_iv, null: false
      t.string :encrypted_secret_iv, null: false
      t.string :screen_name, null: false
      t.string :image_url, null: false

      t.timestamps
    end

    add_index :twitter_accounts, [:organization_id, :twitter_id], unique: true
  end
end

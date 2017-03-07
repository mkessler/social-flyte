class AddIvColumnsToAccessTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :access_tokens, :encrypted_token_iv, :string, null: false
    add_column :access_tokens, :encrypted_secret_iv, :string
  end
end

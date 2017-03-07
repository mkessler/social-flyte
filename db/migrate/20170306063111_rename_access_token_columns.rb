class RenameAccessTokenColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :access_tokens, :token, :encrypted_token
    rename_column :access_tokens, :secret, :encrypted_secret
  end
end

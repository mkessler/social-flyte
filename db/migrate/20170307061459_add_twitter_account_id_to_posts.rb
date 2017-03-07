class AddTwitterAccountIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :twitter_account_id, :integer
  end
end

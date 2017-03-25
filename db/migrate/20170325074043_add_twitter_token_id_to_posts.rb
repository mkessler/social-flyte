class AddTwitterTokenIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :twitter_token_id, :integer
  end
end

class AddIndexToPosts < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, [:user_id, :network_post_id, :network_id], unique: true
  end
end

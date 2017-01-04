class UpdateNetworkPostIdIndexOnPosts < ActiveRecord::Migration[5.0]
  def change
    remove_index :posts, [:campaign_id, :network_post_id]
    add_index :posts, [:campaign_id, :network_id, :network_post_id], unique: true
  end
end

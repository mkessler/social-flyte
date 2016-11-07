class AddCampaignIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :campaign, foreign_key: true
    add_index :posts, [:campaign_id, :network_post_id], unique: true
  end
end

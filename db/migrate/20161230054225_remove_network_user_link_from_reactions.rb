class RemoveNetworkUserLinkFromReactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :reactions, :network_user_link, :string
  end
end

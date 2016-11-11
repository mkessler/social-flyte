class AddColumnsToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sync_count, :integer, null: false, default: 0
    add_column :posts, :synced_at, :datetime
  end
end

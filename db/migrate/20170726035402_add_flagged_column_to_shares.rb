class AddFlaggedColumnToShares < ActiveRecord::Migration[5.0]
  def change
    add_column :shares, :flagged, :boolean, default: false
  end
end

class AddFlaggedColumnToReactions < ActiveRecord::Migration[5.0]
  def change
    add_column :reactions, :flagged, :boolean, default: false
  end
end

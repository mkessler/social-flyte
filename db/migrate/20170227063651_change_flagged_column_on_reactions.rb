class ChangeFlaggedColumnOnReactions < ActiveRecord::Migration[5.0]
  def change
    change_column :reactions, :flagged, :boolean, default: false, null: false
  end
end

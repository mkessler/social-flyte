class ChangeFlaggedColumnOnComments < ActiveRecord::Migration[5.0]
  def change
    change_column :comments, :flagged, :boolean, default: false, null: false
  end
end

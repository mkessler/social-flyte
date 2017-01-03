class AddFlaggedColumnToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :flagged, :boolean, default: false
  end
end

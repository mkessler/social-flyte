class AddFlaggedColumnToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :flagged, :boolean, default: false, null: false
  end
end

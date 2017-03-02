class RenameFavoriteCountsColumnOnTweets < ActiveRecord::Migration[5.0]
  def change
    rename_column :tweets, :favorite_count, :favorite_count
  end
end

class AddScreenNameToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :network_user_screen_name, :string, null: false
  end
end

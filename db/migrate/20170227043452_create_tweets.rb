class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.references :post, index:true, foreign_key: true, null: false
      t.string :network_tweet_id, null: false
      t.string :network_user_id, null: false
      t.string :network_user_name, null: false
      t.integer :favorite_count, null: false, default: 0
      t.integer :retweet_count, null: false, default: 0
      t.text :message, null: false
      t.text :hashtags
      t.datetime :posted_at, null: false

      t.timestamps
    end

    add_index :tweets, [:post_id, :network_tweet_id], unique: true
  end
end

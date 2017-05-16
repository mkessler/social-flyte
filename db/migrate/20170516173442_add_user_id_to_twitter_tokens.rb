class AddUserIdToTwitterTokens < ActiveRecord::Migration[5.0]
  def change
    add_reference :twitter_tokens, :user, foreign_key: true, null: false
  end
end

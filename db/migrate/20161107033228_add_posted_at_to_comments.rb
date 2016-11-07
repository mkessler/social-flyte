class AddPostedAtToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :posted_at, :datetime, null: false
  end
end

class CreateReactions < ActiveRecord::Migration[5.0]
  def change
    create_table :reactions do |t|
      t.string :network_user_id
      t.string :network_user_link
      t.string :network_user_name
      t.string :network_user_picture
      t.string :category

      t.timestamps
    end
  end
end

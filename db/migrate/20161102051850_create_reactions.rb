class CreateReactions < ActiveRecord::Migration[5.0]
  def change
    create_table :reactions do |t|
      t.references :post, index: true, foreign_key: true, null: false
      t.string :network_user_id, null: false
      t.string :network_user_link
      t.string :network_user_name
      t.string :network_user_picture
      t.string :category, index: true, null: false

      t.timestamps
    end

    add_index :reactions, [:post_id, :network_user_id], unique: true
  end
end

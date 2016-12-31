class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :post, index: true, foreign_key: true, null: false
      t.string :network_comment_id, null: false
      t.string :network_user_id, null: false
      t.string :network_user_name, null: false
      t.string :attachment_image
      t.string :attachment_url
      t.string :network_user_name, null: false
      t.integer :like_count, null: false, default: 0
      t.text :message, null: false

      t.timestamps
    end

    add_index :comments, [:post_id, :network_comment_id], unique: true
  end
end

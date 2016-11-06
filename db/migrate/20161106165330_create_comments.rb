class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :post, index: true, foreign_key: true, null: false
      t.string :network_comment_id, null: false
      t.string :network_user_id, null: false
      t.string :network_user_name, null: false
      t.string :like_count, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_index :comments, [:post_id, :network_comment_id], unique: true
  end
end

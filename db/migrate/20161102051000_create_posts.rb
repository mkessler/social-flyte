class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.references :network, index:true, foreign_key: true, null: false
      t.string :network_post_id, null: false
      t.string :network_parent_id

      t.timestamps
    end
  end
end

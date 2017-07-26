class CreateShares < ActiveRecord::Migration[5.0]
  def change
    create_table :shares do |t|
      t.references :post, foreign_key: true, null: false
      t.string :network_user_id, null: false
      t.string :network_user_name, null: false
      t.string :network_share_id, null: false

      t.timestamps
    end

    add_index :shares, [:post_id, :network_share_id], unique: true
  end
end

class CreateNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end
  end
end

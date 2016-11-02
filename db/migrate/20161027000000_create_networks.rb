class CreateNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.string :name, null: false, unique: true
      t.string :slug, index: true, null: false, unique: true

      t.timestamps
    end
  end
end

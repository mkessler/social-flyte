class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.references :organization, foreign_key: true, null: false
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :campaigns, [:organization_id, :name], unique: true
    add_index :campaigns, [:organization_id, :slug], unique: true
  end
end

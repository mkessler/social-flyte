class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.references :organization, foreign_key: true
      t.string :name
      t.string :slug

      t.timestamps
    end

    add_index :campaigns, [:organization_id, :name], unique: true
    add_index :campaigns, [:organization_id, :slug], unique: true
  end
end

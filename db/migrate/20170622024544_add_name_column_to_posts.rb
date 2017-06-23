class AddNameColumnToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :name, :string, null: false
  end
end

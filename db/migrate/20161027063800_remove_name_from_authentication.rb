class RemoveNameFromAuthentication < ActiveRecord::Migration[5.0]
  def change
    remove_column :authentications, :name
  end
end

class AddFieldsToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :attachment_image, :string
    add_column :comments, :attachment_url, :string
  end
end

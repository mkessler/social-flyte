class AddJobIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :job_id, :string
  end
end

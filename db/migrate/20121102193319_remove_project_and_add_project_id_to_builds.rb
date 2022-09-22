class RemoveProjectAndAddProjectIdToBuilds < ActiveRecord::Migration[7.0]
  def change
    remove_column :builds, :project
    add_column :builds, :project_id, :integer
  end
end

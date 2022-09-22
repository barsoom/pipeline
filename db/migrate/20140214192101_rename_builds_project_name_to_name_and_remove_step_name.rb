class RenameBuildsProjectNameToNameAndRemoveStepName < ActiveRecord::Migration[7.0]
  def change
    rename_column :builds, :project_name, :name
    remove_column :builds, :step_name
  end

  def down
  end
end

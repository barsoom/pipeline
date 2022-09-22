class ChangeBuilds < ActiveRecord::Migration[7.0]
  def up
    rename_column :builds, :step, :step_name
    add_column :builds, :project_name, :string

    Build.reset_column_information
    Build.order("id ASC").each do |build|
      build.update_attribute :project_name, Project.find(build.project_id).name
    end

    remove_column :builds, :project_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

class AddMappingsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :mappings, :text
  end
end

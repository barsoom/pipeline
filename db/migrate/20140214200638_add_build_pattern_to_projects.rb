class AddBuildPatternToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :build_pattern, :string
  end
end

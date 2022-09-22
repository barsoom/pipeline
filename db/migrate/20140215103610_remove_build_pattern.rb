class RemoveBuildPattern < ActiveRecord::Migration[7.0]
  def up
    remove_column :projects, :build_pattern
  end

  def down
  end
end

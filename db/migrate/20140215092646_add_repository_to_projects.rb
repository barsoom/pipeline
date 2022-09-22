class AddRepositoryToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :repository, :string
  end
end

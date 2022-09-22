class RemoveGithubUrlFromProjects < ActiveRecord::Migration[7.0]
  def up
    remove_column :projects, :github_url
  end

  def down
  end
end

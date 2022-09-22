class CreateProjects < ActiveRecord::Migration[7.0]
  def up
    create_table :projects do |t|
      t.timestamps
      t.string :name
      t.string :github_url
    end
  end

  def down
    drop_table :projects
  end
end

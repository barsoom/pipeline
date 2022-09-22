class CreateBuilds < ActiveRecord::Migration[7.0]
  def up
    create_table :builds do |t|
      t.timestamps
      t.string :project
      t.string :step
      t.string :revision
      t.string :status
    end
  end

  def down
    drop_table :builds
  end
end

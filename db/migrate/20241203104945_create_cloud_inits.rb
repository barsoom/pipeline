class CreateCloudInits < ActiveRecord::Migration[7.1]
  def change
    create_table :cloud_inits do |t|
      t.string :name, null: false
      t.text :data, null: false

      t.timestamps
    end
  end
end

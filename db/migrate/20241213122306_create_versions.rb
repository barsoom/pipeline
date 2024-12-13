class CreateVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :versions do |t|
      t.string   :whodunnit
      t.datetime :created_at
      t.bigint   :item_id,   null: false
      t.string   :item_type, null: false
      t.string   :event,     null: false
      t.json     :object
      t.json     :object_changes
    end
    add_index :versions, %i[item_type item_id]
  end
end

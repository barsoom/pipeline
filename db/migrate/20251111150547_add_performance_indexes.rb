class AddPerformanceIndexes < ActiveRecord::Migration[8.1]
  # Generated from the output of "script/slow-queries pipeline-postgres" in the stack repo
  disable_ddl_transaction!

  def change
    # Builds
    add_index :builds, :revision_id, algorithm: :concurrently, name: "idx_builds_revision_id"
    add_index :builds, [ :revision_id, :name, :id ], algorithm: :concurrently, name: "idx_builds_revision_name_id"

    # Revisions
    add_index :revisions, [ :project_id, :id ], algorithm: :concurrently, name: "idx_revisions_project_id_id"
    add_index :revisions, [ :project_id, :name, :id ], algorithm: :concurrently, name: "idx_revisions_project_name_id"
    add_index :revisions, [ :project_id, :created_at ], order: { created_at: :desc }, algorithm: :concurrently, name: "idx_revisions_project_created_at"

    # Versions
    add_index :versions, [ :item_id, :item_type, :created_at, :id ], algorithm: :concurrently, name: "idx_versions_item_type_created_id"
  end
end

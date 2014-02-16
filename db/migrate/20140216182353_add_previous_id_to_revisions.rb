class AddPreviousIdToRevisions < ActiveRecord::Migration
  def change
    add_column :revisions, :previous_id, :integer
  end
end

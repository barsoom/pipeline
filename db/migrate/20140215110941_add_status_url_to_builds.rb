class AddStatusUrlToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :status_url, :string
  end
end

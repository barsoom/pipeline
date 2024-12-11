class ChangeCloudInits < ActiveRecord::Migration[7.1]
  def change
    rename_column :cloud_inits, :data, :template
    add_column :cloud_inits, :password_salt, :string
    add_column :cloud_inits, :config, :jsonb, null: false, default: {}

    CloudInit.reset_column_information
    CloudInit.all.each do |cloud_init|
      cloud_init.update_column(:password_salt, SecureRandom.hex(32))
    end

    change_column :cloud_inits, :password_salt, :string, null: false
  end
end

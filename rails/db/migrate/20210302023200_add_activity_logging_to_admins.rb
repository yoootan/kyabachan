class AddActivityLoggingToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :last_login_at, :datetime
    add_column :admins, :last_logout_at, :datetime
    add_column :admins, :last_activity_at, :datetime
    add_column :admins, :last_login_from_ip_address, :string
    add_index :admins, [:last_logout_at, :last_activity_at]
  end
end

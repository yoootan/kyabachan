class AddRememberDigestToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :remember_digest, :string
    add_column :admins, :remember_expires_at, :datetime, default: nil
  end
end

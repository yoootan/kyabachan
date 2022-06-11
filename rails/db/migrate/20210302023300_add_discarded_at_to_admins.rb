class AddDiscardedAtToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :discarded_at, :datetime
    add_index :admins, :discarded_at
  end
end

class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.integer :status, null: false, default: 0
      t.string :email, null: false
      t.string :password_digest

      t.timestamps
    end
    add_index :admins, :email, unique: true
  end
end

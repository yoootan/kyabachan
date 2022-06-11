class CreatePwneds < ActiveRecord::Migration[6.0]
  def change
    create_table :pwneds do |t|
      t.references :pwned_tag, null: false, foreign_key: true
      t.string :password
      t.string :password_sha256

      t.timestamps
    end
    add_index :pwneds, :password
    add_index :pwneds, :password_sha256
  end
end

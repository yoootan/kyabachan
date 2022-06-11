class CreateAppConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :app_configs do |t|
      t.string :title, null: false
      t.text :description

      t.string :key, null: false, unique: true
      t.text :value, limit: 16777215, null: false

      t.timestamps
    end
  end
end

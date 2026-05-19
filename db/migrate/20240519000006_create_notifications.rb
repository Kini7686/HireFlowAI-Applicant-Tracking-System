class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :message, null: false
      t.datetime :read_at
      t.string :notification_type, null: false

      t.timestamps
    end

    add_index :notifications, :read_at
    add_index :notifications, :notification_type
  end
end

class CreateWork < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.integer :minutes, default: 0
      t.string :result
      t.string :message_id
      t.boolean :sprint, default: false
      t.timestamps
    end
  end
end

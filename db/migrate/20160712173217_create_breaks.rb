class CreateBreaks < ActiveRecord::Migration[5.0]
  def change
    create_table :breaks do |t|
      t.belongs_to :user, index: true
      t.integer :minutes, default: 0
      t.integer :min_left, default: 0
      t.string :message_id
      t.timestamps
    end
  end
end

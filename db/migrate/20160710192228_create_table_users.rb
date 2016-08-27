class CreateTableUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :telegram_id
      t.integer :work_time, default: 25
      t.integer :break_time, default: 5
      t.integer :long_break_time, default: 15
      t.integer :state, default: 0
      t.integer :state_step, default: 0
      t.string :locale, default: 'en'
      t.timestamps
    end
  end
end

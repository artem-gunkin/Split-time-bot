class AddTimezoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :timezone, :string, default: 'Europe/Moscow'
  end
end

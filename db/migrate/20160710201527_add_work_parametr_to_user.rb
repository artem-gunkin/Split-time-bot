class AddWorkParametrToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :little_work, :integer, default: 5
    add_column :users, :normal_work, :integer, default: 15
    add_column :users, :big_work, :integer, default: 25
  end
end

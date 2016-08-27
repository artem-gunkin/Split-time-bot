class AddColumnToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :min_left, :integer, default: 0
  end
end

class ChageTableWorks < ActiveRecord::Migration[5.0]
  def change
    rename_column :works, :result, :status
    add_column :works, :type, :string, default: 'task'
    add_column :works, :part, :integer, default: 0
    add_column :users, :sprint_parts, :integer, default: 4
  end
end

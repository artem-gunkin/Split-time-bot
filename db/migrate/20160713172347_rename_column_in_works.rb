class RenameColumnInWorks < ActiveRecord::Migration[5.0]
  def change
    rename_column :works, :type, :task_type
  end
end

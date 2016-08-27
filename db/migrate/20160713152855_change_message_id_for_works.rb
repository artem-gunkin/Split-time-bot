class ChangeMessageIdForWorks < ActiveRecord::Migration[5.0]
  def change
    remove_column :works, :message_id
    add_column :works, :message_id, :integer
  end
end

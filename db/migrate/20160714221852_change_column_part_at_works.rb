class ChangeColumnPartAtWorks < ActiveRecord::Migration[5.0]
  def change
    change_column_default :works, :part, 1
  end
end

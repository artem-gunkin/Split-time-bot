class AddColumnToBreaks < ActiveRecord::Migration[5.0]
  def change
    add_column :breaks, :result, :string, default: 'active'
  end
end

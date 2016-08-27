class AddAssotiationToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :works, :user, index: true
  end
end

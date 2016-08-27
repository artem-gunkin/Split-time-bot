class Break < ApplicationRecord
  belongs_to :user

  def stop
    update_attribute(:result, :stopped)
  end
end

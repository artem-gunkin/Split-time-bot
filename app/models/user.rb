class User < ActiveRecord::Base
  has_many :works
  has_many :breaks
  validates_uniqueness_of :telegram_id

  def change_state(state)
    update_attributes(state: state, state_step: 0)
  end

  def change_step(step)
    update_attribute(:state_step, step)
  end
end

class Work < ActiveRecord::Base
  belongs_to :user

  def is_sprint?
    self.sprint
  end

  def stop
    update_attribute(:status, :stopped)
  end

  def self.today_works(user)
    beginning_of_day = Timezone[user.timezone].utc_to_local(Time.now.beginning_of_day)
    end_of_day = Timezone[user.timezone].utc_to_local(Time.now.end_of_day)
    where(created_at: beginning_of_day..end_of_day, user_id: user.id, status: %w(finished well digress))
  end

  def self.week_works(user)
    beginning_of_week = Timezone[user.timezone].utc_to_local(Time.now.beginning_of_week)
    end_of_week = Timezone[user.timezone].utc_to_local(Time.now.end_of_week)
    where(created_at: beginning_of_week..end_of_week, user_id: user.id, status: %w(finished well digress))
  end

  def self.well_done
    where(status: 'well')
  end

  def self.digressed
    where(status: 'digress')
  end

  def self.forgotten
    where(status: 'forgot')
  end
end

class TaskTimer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, task_id)
    @user = User.find(user_id)
    @task = Work.find(task_id)
    I18n.locale = @user.locale
    return if @task.status == 'stopped'

    if @task.min_left > 1
      worker.start(@task)
    else
      case @task.task_type
        when 'sprint'
          if @task.part < @user.sprint_parts
            worker.create_break(@task)
          else
            worker.finish(@task)
          end
        when 'break'
          worker.create_task(@task)
        else
          worker.finish(@task)
      end
    end
  end

  def worker
    BotCommand::TaskWorker.new(@user)
  end
end
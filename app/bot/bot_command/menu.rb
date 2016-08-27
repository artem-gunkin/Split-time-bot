module BotCommand
  class Menu < Base
    def start
      case step
      when 0
        process
      when 1
        send_message(t :go_work)
      when 2
        stop_working
      when 3
        set_feedback
      end
    end

    private

    def process
      case text
      when t(:timer, min: user.little_work)
        work user.little_work
      when t(:timer, min: user.normal_work)
        work user.normal_work
      when t(:timer, min: user.big_work)
        work user.big_work
      when t(:sprint)
        work user.work_time, true
      when t(:settings)
        settings
      when t(:stats)
        stats
      when t(:help)
        send_message(t(:tutorial))
        send_message(t(:write_me), kb: menu_keyboard)
      else
        false
      end
    end

    def stats
      today_works = Work.today_works(user)
      week_works = Work.week_works(user)
      send_message(t(:stats_info,
                     today_count: today_works.count,
                     today_time: today_works.sum(:minutes),
                     today_well: today_works.well_done.count,
                     today_digress: today_works.digressed.count,
                     today_forgot: today_works.forgotten.count,
                     week_count: week_works.count,
                     week_time: week_works.sum(:minutes),
                     week_well: week_works.well_done.count,
                     week_digress: week_works.digressed.count,
                     week_forgot: week_works.forgotten.count), kb: menu_keyboard)
    end

    def stop_working
      task = Work.find(data.to_i)
      task.stop
      user.change_step 0

      if task.task_type == 'break'
        edit_message(task.message_id, t(:sprint_stopped))
      else
        edit_message(task.message_id, t(:task_stopped, id: task.id, type: t(task.task_type), min: task.minutes))
      end
    end

    def work(min, sprint = false)
      task = user.works.create(status: :active, minutes: min, min_left: min, task_type: sprint && :sprint || :work)
      response = send_message(t(:work_time, min: min, min_left: min, id: task.id, type: t(task.task_type)), inline_kb: stop_keyboard(task.id))
      task.update_attribute(:message_id, id_by(response))
      TaskTimer.perform_in(59.seconds, user.id, task.id)
      user.change_step 1
    end

    def set_feedback
      status_info = data.split('-')[0]
      id = data.split('-')[1].to_i
      task = Work.find(id)
      task.update_attribute(:status, status_info)
      edit_message(task.message_id, t(:task_finish, min: task.minutes, id: task.id, type: t(task.task_type), status: t(status_info)))
    end

    def settings
      send_message(t(:welcome_settings), kb: settings_keyboard)
      user.change_state 2
    end
  end
end
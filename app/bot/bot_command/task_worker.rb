module BotCommand
  class TaskWorker < Base
    def start(task)
      response = edit_message(task.message_id, t(:work_time, id: task.id, type: t(task.task_type), min: task.minutes, min_left: task.min_left - 1), stop_keyboard(task.id))
      task.update_attributes(message_id: id_by(response), min_left: task.min_left - 1)
      TaskTimer.perform_in(59.seconds, user.id, task.id)
    end

    def create_break(task)
      finish_task(task)

      task = user.works.create(minutes: user.break_time, min_left: user.break_time, task_type: :break, part: task.part)
      response = send_message(t(:break_time, min: task.minutes, min_left: task.min_left), inline_kb: stop_keyboard(task.id))
      task.update_attribute(:message_id, id_by(response))
      TaskTimer.perform_in(59.seconds, user.id, task.id)
    end

    def create_task(task)
      task.update_attributes(status: :finished, min_left: 0)
      edit_message(task.message_id, t(:break_finished, min: task.minutes))

      min = user.work_time
      task = user.works.create(minutes: min, min_left: min, task_type: :sprint, part: task.part + 1)
      response = send_message(t(:work_time, min: min, min_left: min, id: task.id, type: t(:sprint)), inline_kb: stop_keyboard(task.id))
      task.update_attribute(:message_id, id_by(response))
      TaskTimer.perform_in(59.seconds, user.id, task.id)
    end

    def finish_task(task)
      task.update_attributes(status: :finished, min_left: 0)
      edit_message(task.message_id, t(:work_finished, id: task.id, type: t(task.task_type), min: task.minutes), feedback_keyboard(task.id))
    end

    def finish(task)
      finish_task(task)

      if task.task_type == 'sprint'
        if task.part == user.sprint_parts
          send_message(t(:last_break_time), kb: menu_keyboard)
        else
          send_message(t(:break_time, min: task.minutes, min_left: task.min_left), kb: menu_keyboard)
        end
      else
        send_message(t(:relax_time), kb: menu_keyboard)
      end

      user.change_step 0
    end

    def feedback_keyboard(id)
      [
          add_key(t(:well), "1:3:well-#{id}"),
          add_key(t(:digress), "1:3:digress-#{id}"),
          add_key(t(:forgot), "1:3:forgot-#{id}")
      ]
    end
  end
end

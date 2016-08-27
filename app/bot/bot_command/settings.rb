module BotCommand
  class Settings < Base
    def start
      case step
        when 0
          process
        when 1
          set_timer
        when 2
          set_lang
        when 3
          set_sprint
        when 4
          set_timezone
      end
    end

    def set_timezone
      if location_data
        timezone = Timezone.lookup(location_data[:latitude], location_data[:longitude])
        user.update_attributes(timezone: timezone.name, state_step: 0)
        send_message(t(:timezone_saved), kb: settings_keyboard)
      else
        send_message(t(:send_locaton_again), kb: location_kb)
      end
    end

    def set_lang
      case text
      when t(:lang_ru)
        locale = 'ru'
      when t(:lang_en)
        locale = 'en'
      else
        send_message(t(:wrong_lang), kb: lang_keyboard)
      end

      I18n.locale = locale
      user.update(locale: locale, state: 2, state_step: 0)
      send_message(t(:lang_saved), kb: settings_keyboard)
    end

    def set_timer
      unless text =~ /^\d{1,2}\s\d{1,2}\s\d{1,2}$/
        send_message(t(:invalid_options))
        return true
      end

      timers = text.split(' ')
      user.little_work = timers[0].to_i
      user.normal_work = timers[1].to_i
      user.big_work    = timers[2].to_i
      user.state_step = 0
      user.save
      send_message(t(:timer_save), kb: settings_keyboard)
    end

    def set_sprint
      unless text =~ /^\d{1,2}\s\d{1,2}\s\d{1,2}$/
        send_message(t(:invalid_options))
        return true
      end

      timers = text.split(' ')
      user.work_time = timers[0].to_i
      user.break_time = timers[1].to_i
      user.sprint_parts = timers[2].to_i
      user.state_step = 0
      user.save
      send_message(t(:sprint_save), kb: settings_keyboard)
    end

    def change_timer
      send_message(t(:change_timer_message), kb: [])
      user.change_step 1
    end

    def change_lang
      send_message(t(:choose_lang), kb: lang_keyboard)
      user.change_step 2
    end

    def change_sprint
      send_message(t(:change_sprint_message), kb: [])
      user.change_step 3
    end

    def process
      case text
        when t(:standard_timer)
          change_timer
        when t(:lang)
          change_lang
        when t(:sprint)
          change_sprint
        when t(:time)
          change_time
        when t(:menu)
          go_menu
        else
          false
      end
    end

    def change_time
      send_message(t(:send_locaton), kb: location_kb)
      user.change_step 4
    end

    def location_kb
      Telegram::Bot::Types::KeyboardButton.new(text: t(:location), request_location: true)
    end

    def go_menu
      user.change_state 1
      send_message(t(:settting_changed), kb: menu_keyboard)
    end
  end
end
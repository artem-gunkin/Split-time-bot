module BotCommand
  class Start < Base
    def start
      case step
        when 0
          choose_lang
        when 1
          choose_lang_again
        when 2
          set_lang
        else
          false
      end
    end

    private

    def set_lang
      case text
      when t(:lang_ru)
        locale = 'ru'
      when t(:lang_en)
        locale = 'en'
      else
        return send_message(t(:wrong_lang), kb: lang_keyboard)
      end

      I18n.locale = locale
      user.update(locale: locale, state: 1, state_step: 0)
      send_message(t(:tutorial), kb: menu_keyboard)
    end

    def choose_lang
      send_message(t :welcome)
      send_message(t(:choose_lang), kb: lang_keyboard)
      user.update(state_step: 2)
    end

    def choose_lang_again
      send_message(t(:choose_lang_above))
    end

    def lang_keyboard
      [
          add_key(t(:lang_ru), '0:2ru'),
          add_key(t(:lang_en), '0:2:en')
      ]
    end
  end
end
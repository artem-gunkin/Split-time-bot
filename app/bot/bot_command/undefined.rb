module BotCommand
  class Undefined < Base
    def start
      send_message(t(:undefined), kb: keyboard)
    end

    def keyboard
      case user.state
        when 1
          menu_keyboard
        when 2
          settings_keyboard
      end
    end
  end
end
class BotDispatcher
  attr_reader :message, :user

  AVAILABLE_STATES = [
      BotCommand::Start,
      BotCommand::Menu,
      BotCommand::Settings
  ]

  def initialize(message, user)
    @message = message
    @user = user
  end

  def process_message
    state_handler = state.new(@user, @message)
    state_handler.start || unknown_command
  end

  def process_callback
    state_handler = data_state.new(@user, @message)
    state_handler.start || unknown_command
  end

  def state
    AVAILABLE_STATES[@user.state]
  end

  def data_state
    full_date = @message[:callback_query][:data].split(':')
    if full_date.size == 1
      state
    else
      AVAILABLE_STATES[full_date[0].to_i]
    end
  end

  def unknown_command
    BotCommand::Undefined.new(@user, @message).start
  end
end


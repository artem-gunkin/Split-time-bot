require 'telegram/bot'

module BotCommand
  class Base
    attr_reader :user, :message, :api, :reply_markup

    def initialize(user, message = nil)
      token = Rails.application.secrets.bot_token
      @user = user
      @message = message
      @api = ::Telegram::Bot::Api.new(token)
    end

    def start
      raise NotImplementedError
    end

    protected

    def send_message(text, inline_kb: nil, kb: nil)
      include_keyboard_markup(kb) if kb
      include_inline_keyboard(inline_kb) if inline_kb
      @api.call('sendMessage', chat_id: @user.telegram_id, text: text, reply_markup: @reply_markup, parse_mode: 'Markdown')
    end

    def send_sticker(id)
      @api.call('sendSticker', chat_id: @user.telegram_id, sticker: id)
    end

    def clean_markup(id = nil)
      empty_inline_keyboard
      @api.call('editMessageReplyMarkup', chat_id: @user.telegram_id, message_id: id || message_id, reply_markup: @reply_markup)
    end

    def edit_message(id, text, keyboard = nil)
      keyboard && include_inline_keyboard(keyboard) || empty_inline_keyboard
      @api.call('editMessageText', chat_id: @user.telegram_id, text: text, message_id: id, reply_markup: @reply_markup, parse_mode: 'Markdown')
    end

    def edit_markup(keyboard)
      @reply_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      @api.call('editMessageReplyMarkup', chat_id: @user.telegram_id, message_id: message_id, reply_markup: @reply_markup)
    end

    def include_keyboard_markup(kb)
      @reply_markup =
          Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, one_time_keyboard: true, resize_keyboard: true)
    end

    def include_inline_keyboard(kb)
      @reply_markup =
          Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    end

    def empty_inline_keyboard
      @reply_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [])
    end

    def step
      data_step || @user.state_step
    end

    def text
      @message[:message][:text]
    end

    def full_data
      @message[:callback_query][:data].split(':')
    end

    def data
      return full_data[2] if full_data.size > 1
      full_data[0]
    end

    def data_step
      full_data[1].to_i if @message[:callback_query] && full_data.size > 1
    end

    def from
      @message[:message][:from]
    end

    def message_id
      @message[:callback_query] && @message[:callback_query][:message][:message_id] || @message[:message][:message_id]
    end

    def location_data
      @message[:message][:location]
    end

    def t(*args)
      I18n.t(*args)
    end

    def add_key(text, callback)
      Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: callback)
    end

    def menu_keyboard
      [
          [t(:timer, min: user.little_work), t(:timer, min: user.normal_work), t(:timer, min: user.big_work)],
          [t(:sprint)],
          [t(:stats)],
          [t(:help), t(:settings)],
      ]
    end

    def stop_keyboard(id)
      add_key(t(:stop), "1:2:#{id}")
    end

    def settings_keyboard
      [t(:standard_timer), [t(:sprint)], [t(:lang), t(:time)], t(:menu)]
    end

    def lang_keyboard
      [t(:lang_ru), t(:lang_en)]
    end

    def id_by(response)
      response['result']['message_id'].to_i
    end
  end
end
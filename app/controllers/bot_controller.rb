class BotController < ApplicationController
  before_action :set_locale

  def callback
    dispatcher.process_message if params[:message]
    dispatcher.process_callback if params[:callback_query]
    render body: nil
  end

  def dispatcher
    BotDispatcher.new(params, user)
  end


  def from
    message[:from]
  end

  def message
    params[:message] || params[:callback_query]
  end

  def user
    @user ||= User.find_by(telegram_id: from[:id]) || register_user
  end

  def register_user
    @user = User.find_or_initialize_by(telegram_id: from[:id])
    @user.update_attributes!(first_name: from[:first_name], last_name: from[:last_name], username: from[:username])
    @user
  end

  def set_locale
    I18n.locale = user.locale || I18n.default_locale
  end
end
class BaseService
  def initialize(user, update)
    self.user = user
    self.update = update
  end

  def call
    raise 'Implement me!'
  end

  protected
  attr_accessor :user, :update

  def client
    @client ||= Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def chat_id
    message.chat.id
  end

  def message
    update.inline_query ||
      update.chosen_inline_result ||
      update.callback_query ||
      update.edited_message ||
      update.message
  end
end

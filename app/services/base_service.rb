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
    update.callback_query.try!(:message) || update.message
  end
end

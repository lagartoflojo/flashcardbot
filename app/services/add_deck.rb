class AddDeck
  def initialize(user, update)
    self.user = user
    self.update = update
    self.client = Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def call
    chat_id = update.message.chat.id
    client.api.send_message(chat_id: chat_id, text: "What’s the name of this deck?")
    user.adding_deck!
  end

  private
  attr_accessor :user, :update, :client
end

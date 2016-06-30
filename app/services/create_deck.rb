class CreateDeck
  def initialize(user, update)
    self.user = user
    self.update = update
    self.client = Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def call
    user.decks.find_or_create_by name: deck_name
    user.adding_front_side!
    client.api.send_message(chat_id: chat_id, text: "Deck “#{deck_name}” created!\nLet’s add a card to it.\nSend me the front side of the card.")
  end

  private
  attr_accessor :user, :update, :client

  def deck_name
    update.message.text
  end

  def chat_id
    update.message.chat.id
  end
end

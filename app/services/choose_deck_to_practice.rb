class ChooseDeckToPractice
  def initialize(user, update)
    self.user = user
    self.update = update
    self.client = Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def call
    keys = user.decks.latest.map { |deck| [Telegram::Bot::Types::KeyboardButton.new(text: deck.name)] }
    keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup.new({
      keyboard: keys,
      resize_keyboard: true,
      one_time_keyboard: true
    })
    client.api.send_message(chat_id: chat_id, text: "Choose the deck you want to practice.", reply_markup: keyboard)
    user.choosing_deck_to_practice!
  end

  private
  attr_accessor :user, :update, :client

  def chat_id
    update.message.chat.id
  end
end

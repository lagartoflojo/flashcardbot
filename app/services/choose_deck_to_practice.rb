class ChooseDeckToPractice < BaseService
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
end

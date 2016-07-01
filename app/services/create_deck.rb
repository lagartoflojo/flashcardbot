class CreateDeck < BaseService
  def call
    user.decks.find_or_create_by name: deck_name
    user.adding_front_side!
    client.api.send_message(chat_id: chat_id, text: "Deck “#{deck_name}” created!\nLet’s add a card to it.\nSend me the front side of the card.")
  end

  private
  def deck_name
    update.message.text
  end
end

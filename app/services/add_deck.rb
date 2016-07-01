class AddDeck < BaseService
  def call
    client.api.send_message(chat_id: chat_id, text: "What’s the name of this deck?")
    user.adding_deck!
  end
end

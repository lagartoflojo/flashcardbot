class FinishAddingCards < BaseService
  def call
    delete_current_card if user.adding_back_side?
    user.waiting!
    client.api.send_message(chat_id: chat_id, text: "Done adding cards to the deck “#{deck.name}”.\nWhat do you want to do now?")
  end

  private
  def delete_current_card
    deck.cards.latest.first.destroy
  end

  def deck
    user.decks.latest.first
  end
end

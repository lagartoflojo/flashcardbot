class AddCardFrontSide < BaseService
  def call
    create_card
    client.api.send_message(chat_id: chat_id, text: "Got it! Now send me the back side.")
    user.adding_back_side!
  end

  private
  def create_card
    side = CreateCardSide.new(update).call
    deck.cards.create front_side: side
  end

  def deck
    # Potentially add a state machine to the decks.
    # Then, here we could look for the one deck that is in state "editing".
    user.decks.latest.first
  end
end

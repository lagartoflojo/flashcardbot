class AddCardBackSide < BaseService
  def call
    add_back_side_to_latest_card
    client.api.send_message(chat_id: chat_id, text: "Card added.\nTo add a new card, send me the front side.\nOtherwise, send /done.")
    user.adding_front_side!
  end

  private
  def add_back_side_to_latest_card
    side = CreateCardSide.new(update).call
    card = deck.cards.latest.first
    card.back_side = side
    card.save
  end

  def deck
    # Potentially add a state machine to the decks.
    # Then, here we could look for the one deck that is in state "editing".
    # Or use user.current_deck
    # Or look at the latest action from that user in the log
    user.decks.latest.first
  end
end

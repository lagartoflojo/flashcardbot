class ShowCardFrontSide < BaseService
  def call
    send_card
  end

  private
  def send_card
    side = card.front_side

    if side.photo_id?
      client.api.send_message(chat_id: chat_id, caption: side.text, photo: side.photo_id)
    elsif side.document_id?
      client.api.send_message(chat_id: chat_id, document: side.document_id)
    else
      client.api.send_message(chat_id: chat_id, text: card.front_side.text)
    end
  end

  def card
    return @card if defined? @card
    @card = deck.cards.random.first
    user.update current_card: @card
    @card
  end

  def deck
    user.current_deck
  end
end

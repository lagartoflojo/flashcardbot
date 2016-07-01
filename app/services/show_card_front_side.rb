class ShowCardFrontSide < BaseService
  def call
    send_card
  end

  private
  def send_card
    side = card.front_side

    message_attrs = { chat_id: chat_id }

    if side.photo_id?
      message_attrs.merge!(photo: side.photo_id)
      message_attrs.merge!(caption: side.text) if side.text?
    elsif side.document_id?
      message_attrs.merge!(document: side.document_id)
    else
      message_attrs.merge!(text: side.text)
    end

    client.api.send_message message_attrs
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

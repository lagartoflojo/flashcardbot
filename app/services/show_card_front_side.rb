class ShowCardFrontSide < BaseService
  def call
    send_card
    user.showing_front_side!
  end

  private
  def send_card
    side = card.front_side

    message_attrs = { chat_id: chat_id, reply_markup: keyboard }

    if side.photo_id?
      message_attrs.merge!(photo: side.photo_id)
      message_attrs.merge!(caption: side.text) if side.text?
      client.api.send_photo message_attrs
    elsif side.document_id?
      message_attrs.merge!(document: side.document_id)
      client.api.send_document message_attrs
    else
      message_attrs.merge!(text: side.text)
      client.api.send_message message_attrs
    end
  end

  def keyboard
    button = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Show answer', callback_data: 'show')
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [[button]])
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

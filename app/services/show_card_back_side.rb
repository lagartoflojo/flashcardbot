class ShowCardBackSide < BaseService
  def call
    clear_show_answer_button
    send_card
    user.showing_back_side!
  end

  private
  def clear_show_answer_button
    client.api.edit_message_reply_markup(
      chat_id: chat_id,
      message_id: message_id
    )
  end

  def send_card
    side = card.back_side

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
    # These should depend on the card history
    buttons = ['Again', 'Hard', 'Good', 'Easy'].map do |button|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: button, callback_data: button.downcase)
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [buttons])
  end

  def card
    @card ||= user.current_card
  end

  def deck
    user.current_deck
  end

  def chat_id
    update.callback_query.message.chat.id
  end

  def message_id
    update.callback_query.message.message_id
  end
end

class SetCardDifficulty < BaseService
  def call
    clear_difficulty_buttons
    ShowCardFrontSide.new(user, update).call
  end

  private
  def clear_difficulty_buttons
    client.api.edit_message_reply_markup(
      chat_id: chat_id,
      message_id: message_id
    )
  end

  def chat_id
    update.callback_query.message.chat.id
  end

  def message_id
    update.callback_query.message.message_id
  end
end

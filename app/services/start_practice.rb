class StartPractice < BaseService
  def call
    if deck
      client.api.send_message(chat_id: chat_id, text: 'Great! Let’s get started!')
      user.update current_deck: deck
      user.showing_front_side!
      ShowCardFrontSide.new(user, update).call
    else
      client.api.send_message(chat_id: chat_id, text: 'I couldn’t find a deck by that name.')
      ChooseDeckToPractice.new(user, update).call
    end
  end

  private
  def deck
    user.decks.find_by(name: deck_name)
  end

  def deck_name
    update.message.text
  end
end

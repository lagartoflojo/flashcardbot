class FinishAddingCards
  def initialize(user, update)
    self.user = user
    self.update = update
    self.client = Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def call
    delete_current_card if user.adding_back_side?
    user.waiting!
    client.api.send_message(chat_id: chat_id, text: "Done adding cards to the deck “#{deck.name}”.\nWhat do you want to do now?")
  end

  private
  attr_accessor :user, :client, :update

  def delete_current_card
    deck.cards.latest.first.destroy
  end

  def chat_id
    update.message.chat.id
  end

  def deck
    user.decks.latest.first
  end
end

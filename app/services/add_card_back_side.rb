class AddCardBackSide
  def initialize(user, update)
    self.user = user
    self.update = update
    self.client = Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def call
    add_back_side_to_latest_card
    client.api.send_message(chat_id: chat_id, text: "Card added.\nTo add a new card, send me the front side.\nOtherwise, send /done.")
    user.adding_front_side!
  end

  private
  attr_accessor :user, :update, :client

  def add_back_side_to_latest_card
    side = CreateCardSide.new(update).call
    card = deck.cards.latest.first
    card.back_side = side
    card.save
  end

  def chat_id
    update.message.chat.id
  end

  def deck
    # Potentially add a state machine to the decks.
    # Then, here we could look for the one deck that is in state "editing".
    user.decks.latest.first
  end
end

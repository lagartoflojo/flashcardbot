class AddCardFrontSide
  def initialize(user, update)
    self.user = user
    self.update = update
    self.client = Telegram::Bot::Client.new(Rails.application.secrets.bot_token)
  end

  def call
    create_card
    client.api.send_message(chat_id: chat_id, text: "Got it! Now send me the back side.")
    user.adding_back_side!
  end

  private
  attr_accessor :user, :update, :client

  def create_card
    card = deck.cards.create
    side = CardSide.create(text: card_text)
    card.front_side = side
    card.save
  end

  def chat_id
    update.message.chat.id
  end

  def card_text
    update.message.text
  end

  def deck
    # Potentially add a state machine to the decks.
    # Then, here we could look for the one deck that is in state "editing".
    user.decks.latest.first
  end
end

class ProcessUpdate
  def initialize(user, update)
    self.user = user
    self.update = update
  end

  def call
    send(user.chat_status)
  end

  private
  attr_accessor :user, :update

  def waiting
    command = update.message.text
    case command
    when /.*\/newdeck.*/
      AddDeck.new(user, update).call
    when /.*\/practice.*/
      ChooseDeckToPractice.new(user, update).call
    end
  end

  def adding_deck
    CreateDeck.new(user, update).call
  end

  def adding_front_side
    command = update.message.try! :text
    case command
    when /.*\/done.*/
      FinishAddingCards.new(user, update).call
    else
      AddCardFrontSide.new(user, update).call
    end
  end

  def adding_back_side
    command = update.message.try! :text
    case command
    when /.*\/done.*/
      FinishAddingCards.new(user, update).call
    else
      AddCardBackSide.new(user, update).call
    end
  end
end

class AddDeck
  def initialize(user, update)
    self.user = user
    self.update = update
  end

  def call

  end

  private
  attr_accessor :user, :update

end

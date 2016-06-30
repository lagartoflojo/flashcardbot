class CreateCardSide
  def initialize(update)
    self.update = update
  end

  def call
    if card_text = update.message.text
      CardSide.create(text: card_text)
    elsif update.message.photo.present?
      photos = update.message.photo
      CardSide.create(photo_id: photos.first.file_id, text: update.message.caption)
    elsif document = update.message.document
      CardSide.create(document_id: document.file_id)
    end
  end

  private
  attr_accessor :update
end

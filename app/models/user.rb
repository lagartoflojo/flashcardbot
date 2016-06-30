class User < ApplicationRecord
  enum chat_status: [
    :waiting,
    :adding_deck,
    :adding_front_side,
    :adding_back_side,
    :choosing_deck_to_edit,
    :showing_front_side,
    :showing_back_side
  ]

  validates :first_name, :telegram_id, presence: true
end

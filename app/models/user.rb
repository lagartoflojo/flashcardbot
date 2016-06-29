class User < ApplicationRecord
  validates :first_name, :telegram_id, presence: true
end

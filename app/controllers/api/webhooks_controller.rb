class Api::WebhooksController < ApplicationController
  before_action :verify_bot_token

  def create
    ProcessUpdate.new(user, update).call
    head :ok
  end

  private
  def verify_bot_token
    unless params[:token] == Rails.application.secrets.bot_token
      head :not_found
    end
  end

  def user
    User.find_or_create_by(telegram_id: message.from.id) do |user|
      user.first_name = message.from.first_name
      user.last_name = message.from.last_name
      user.username = message.from.username
    end
  end

  def update
    @update ||= Telegram::Bot::Types::Update.new(params.to_unsafe_h)
  end

  def message
    update.inline_query ||
      update.chosen_inline_result ||
      update.callback_query ||
      update.edited_message ||
      update.message
  end
end

class Api::WebhooksController < ApplicationController
  before_action :verify_bot_token

  def create
    ProcessUpdate.new(user, params).call
    head :ok
  end

  private
  def verify_bot_token
    unless params[:token] == Rails.application.secrets.bot_token
      head :not_found
    end
  end

  def user
    User.find_or_create_by(telegram_id: params[:message][:from][:id]) do |user|
      user.first_name = params[:message][:from][:first_name]
      user.last_name = params[:message][:from][:last_name]
      user.username = params[:message][:from][:username]
    end
  end
end

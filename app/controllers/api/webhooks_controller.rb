class Api::WebhooksController < ApplicationController
  before_action :verify_bot_token

  def create
    head :ok
  end

  private
  def verify_bot_token
    unless params[:token] == Rails.application.secrets.bot_token
      head :not_found
    end
  end
end

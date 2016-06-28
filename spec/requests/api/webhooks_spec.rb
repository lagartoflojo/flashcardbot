require 'rails_helper'

RSpec.describe "Telegram Webhook" do
  subject { response }
  let(:token) { Rails.application.secrets.bot_token }
  let(:params) { {} }
  let(:webhook) { -> { post '/api/webhook/' + token, params: params } }

  describe 'authentication' do
    before { webhook.call }

    context 'with the correct token' do
      it { is_expected.to be_success }
    end

    context 'with the correct token' do
      let(:token) { 'dummytoken' }
      it { is_expected.to be_not_found }
    end
  end
end

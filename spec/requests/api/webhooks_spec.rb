require 'rails_helper'

RSpec.describe "Telegram Webhook" do
  let(:token) { Rails.application.secrets.bot_token }
  let(:params) { { message: { from: { id: 13182073, first_name: "Hernán", last_name: "Schmidt", username: "hernan" } } } }
  let(:webhook) { -> { post '/api/webhook/' + token, params: params } }

  describe 'authentication' do
    before { webhook.call }
    subject { response }

    context 'with the correct token' do
      it { is_expected.to be_success }
    end

    context 'with the correct token' do
      let(:token) { 'dummytoken' }
      it { is_expected.to be_not_found }
    end
  end

  describe 'user handling' do
    context 'when the user does not exist yet' do
      it 'creates a new user' do
        expect { webhook.call }.to change { User.count }.by(1)
      end
    end

    context 'when the user already exists' do
      before { User.create telegram_id: 13182073, first_name: "Hernán" }

      it 'does not create a new user' do
        expect { webhook.call }.to change { User.count }.by(0)
      end

      it 'updates the user data with the latest one from Telegram'
    end
  end

  describe 'process update' do
    it 'calls the ProcessUpdate service' do
      expect_any_instance_of(ProcessUpdate).to receive(:call)
      webhook.call
    end
  end
end

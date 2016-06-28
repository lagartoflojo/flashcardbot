require 'rails_helper'

RSpec.describe "Telegram Webhook" do

  describe 'authentication' do
    before { post '/api/webhook/' + token }
    subject { response }

    context 'with the correct token' do
      let(:token) { Rails.application.secrets.bot_token }
      it { is_expected.to be_success }
    end

    context 'with the correct token' do
      let(:token) { 'dummytoken' }
      it { is_expected.to be_not_found }
    end
  end
end

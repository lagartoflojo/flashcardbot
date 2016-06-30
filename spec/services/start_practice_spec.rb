RSpec.describe StartPractice do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let(:update_hash) {
    {:update_id=>321321,
      :message =>
      {:message_id=>38,
        :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=>deck_name,
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { StartPractice.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"Let’s get started!"}.to_json
  }
  let!(:deck) { user.decks.create name: 'German 1000' }

  before do
    allow_any_instance_of(ShowCardFrontSide).to receive(:call)
    allow_any_instance_of(ChooseDeckToPractice).to receive(:call)
  end

  context 'when the given deck name exists' do
    let(:deck_name) { 'German 1000' }
    let!(:stub) {
      stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
        with(:body => {"chat_id"=>"1", "text"=>/Let’s get started!/}).
        to_return(:status => 200, :body => api_response)
    }

    it 'calls the ShowCardFrontSide service' do
      expect_any_instance_of(ShowCardFrontSide).to receive(:call)
      service.call
    end

    it 'sets the current deck on the user' do
      service.call
      expect(user.current_deck).to eq deck
    end

    it 'sends a motivating message' do
      service.call
      expect(stub).to have_been_requested
    end

    it 'sets the user status to showing_front_side' do
      service.call
      expect(user).to be_showing_front_side
    end
  end

  context 'when the given deck name does not exist' do
    let(:deck_name) { 'Spanish' }
    let!(:stub) {
      stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
        with(:body => {"chat_id"=>"1", "text"=>/couldn’t find/}).
        to_return(:status => 200, :body => api_response)
    }

    it 'tells the user that the deck was not found' do
      service.call
      expect(stub).to have_been_requested
    end

    it 'calls the ChooseDeckToPractice service' do
      expect_any_instance_of(ChooseDeckToPractice).to receive(:call)
      service.call
    end
  end
end

RSpec.describe FinishAddingCards do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let!(:deck) { user.decks.create name: 'German 1000' }
  let(:service) { FinishAddingCards.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"Done adding cards..."}.to_json
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:update_hash) {
    {:update_id=>321321,
      :message=>
      {:message_id=>38,
        :from=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=> '/done',
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>5}]}}
  }
  let!(:stub) {
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
      with(:body => {"chat_id" => "123123", "text" => /Done adding cards/}).
      and_return(status: 200, body: api_response)
  }

  before do
    user.adding_front_side!
  end

  it 'puts the user in the waiting status' do
    service.call
    expect(user).to be_waiting
  end

  it 'sends a friendly message to the user' do
    service.call
    expect(stub).to have_been_requested
  end

  context 'when the user in the adding_back_side status' do
    before do
      user.adding_back_side!
      deck.cards.create
    end

    it 'deletes the partially-added card' do
      service.call
      expect(deck.cards.reload).to be_empty
    end
  end
end

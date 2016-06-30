RSpec.describe AddCardBackSide do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let!(:deck) { user.decks.create name: 'German 1000' }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { AddCardBackSide.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"Card added..."}.to_json
  }

  before do
    front_side = CardSide.create text: 'cat'
    deck.cards.create front_side: front_side
  end

  context 'receiving a text message' do
    let(:update_hash) {
      {:update_id=>321321,
        :message =>
        {:message_id=>38,
          :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
          :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
          :date=>1467277868,
          :text=>"die Katze"}}
    }

    before do
      stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
        with(:body => {"chat_id"=>"1", "text"=>/Card added/}).
        and_return(status: 200, body: api_response)
    end

    it 'changes the user status to adding_front_side' do
      service.call
      expect(user).to be_adding_front_side
    end

    it 'creates a card new card side' do
      expect { service.call }.to change { CardSide.count }.by(1)
    end
  end

end

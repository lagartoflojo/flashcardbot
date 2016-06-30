RSpec.describe CreateDeck do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let(:update_hash) {
    {:update_id=>321321,
      :message =>
      {:message_id=>38,
        :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=>"German 1000",
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { CreateDeck.new(user, update) }

  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"Deck created!"}.to_json
  }


  context "when it receives a message with the new deck's name" do
    before do
      stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
        with(:body => {"chat_id" => "1", "text" => /created/}).
        and_return(status: 200, body: api_response)
    end

    it 'creates a new deck with the given name' do
      service.call
      expect(user.decks.find_by(name: 'German 1000')).not_to be_nil
    end

    it 'changes the user status to adding_front_side' do
      service.call
      expect(user).to be_adding_front_side
    end

    it 'handles the case when the deck already exists'
  end

end

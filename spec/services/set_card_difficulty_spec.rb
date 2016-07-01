RSpec.describe SetCardDifficulty do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let(:update_hash) {
    {:update_id=>886749750,
     :callback_query=>
      {:id=>"56616574218956195",
       :from=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
       :message=>
        {:message_id=>125,
         :from=>{:id=>239479818, :first_name=>"Hippocardus", :username=>"hippocardusbot"},
         :chat=>
          {:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
         :date=>1467379117,
         :text=>"die Katze"},
       :data=>"good"}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { SetCardDifficulty.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"cat"}.to_json
  }
  let(:deck) { user.decks.create name: 'German 1000' }
  let!(:clear_keyboard_stub) {
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/editMessageReplyMarkup").
      with(:body => {"chat_id"=>"1", "message_id" => "125"}).
      to_return(:status => 200, :body => api_response)
  }

  before { allow_any_instance_of(ShowCardFrontSide).to receive(:call) }

  it 'clears the previous keyboard' do
    service.call
    expect(clear_keyboard_stub).to have_been_requested
  end

  it 'calls the ShowCardFrontSide service' do
    expect_any_instance_of(ShowCardFrontSide).to receive(:call)
    service.call
  end

  it 'saves the card difficulty'
end

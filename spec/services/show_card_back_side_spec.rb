RSpec.describe ShowCardBackSide do
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
         :text=>"cat"},
       :data=>"show"}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { ShowCardBackSide.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"cat"}.to_json
  }
  let(:deck) { user.decks.create name: 'German 1000' }
  let!(:card) {
    back_side = CardSide.create back_side_attrs
    deck.cards.create back_side: back_side
  }
  let!(:stub) {
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/#{api_method}").
      with(:body => {"chat_id"=>"1", "reply_markup" => /Again|Hard|Good|Easy/}.merge(body_attrs)).
      to_return(:status => 200, :body => api_response)
  }
  let!(:clear_keyboard_stub) {
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/editMessageReplyMarkup").
      with(:body => {"chat_id"=>"1", "message_id" => "125"}).
      to_return(:status => 200, :body => api_response)
  }
  let(:back_side_attrs) { { text: 'cat' } }
  let(:body_attrs) { { text: 'cat' } }
  let(:api_method) { 'sendMessage' }

  before do
    user.update current_deck: deck, current_card: card
  end

  it 'sets the user status to showing_back_side' do
    service.call
    expect(user).to be_showing_back_side
  end

  it "clears the previous message's inline keyboard" do
    service.call
    expect(clear_keyboard_stub).to have_been_requested
  end

  describe 'sending a card' do
    context 'with text' do
      it 'sends the user the back side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end

    context 'with a photo' do
      let(:back_side_attrs) { { photo_id: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:body_attrs) { { photo: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:api_method) { 'sendPhoto' }

      it 'sends the user the back side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end

    context 'with a photo + caption' do
      let(:back_side_attrs) { { photo_id: 'NjkanDKJSANDASjdnAKJDSnASKd', text: 'cat' } }
      let(:body_attrs) { { photo: 'NjkanDKJSANDASjdnAKJDSnASKd', caption: 'cat' } }
      let(:api_method) { 'sendPhoto' }

      it 'sends the user the back side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end

    context 'with a document' do
      let(:back_side_attrs) { { document_id: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:body_attrs) { { document: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:api_method) { 'sendDocument' }

      it 'sends the user the back side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end
  end
end

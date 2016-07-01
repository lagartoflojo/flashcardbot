RSpec.describe ShowCardFrontSide do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let(:update_hash) {
    {:update_id=>321321,
      :message =>
      {:message_id=>38,
        :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=>"/practice",
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { ShowCardFrontSide.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"cat"}.to_json
  }
  let(:deck) { user.decks.create name: 'German 1000' }
  let!(:card) {
    front_side = CardSide.create front_side_attrs
    deck.cards.create front_side: front_side
  }
  let!(:stub) {
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/#{api_method}").
    with(:body => {"chat_id"=>"1"}.merge(body_attrs)).
    to_return(:status => 200, :body => api_response)
  }
  let(:front_side_attrs) { { text: 'cat' } }
  let(:body_attrs) { { text: 'cat' } }
  let(:api_method) { 'sendMessage' }

  before do
    user.update current_deck: deck
  end

  it 'sets the current card on the user' do
    service.call
    expect(user.current_card).to eq card
  end

  describe 'sending a card' do
    context 'with text' do
      it 'sends the user the front side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end

    context 'with a photo' do
      let(:front_side_attrs) { { photo_id: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:body_attrs) { { photo: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:api_method) { 'sendPhoto' }

      it 'sends the user the front side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end

    context 'with a photo + caption' do
      let(:front_side_attrs) { { photo_id: 'NjkanDKJSANDASjdnAKJDSnASKd', text: 'cat' } }
      let(:body_attrs) { { photo: 'NjkanDKJSANDASjdnAKJDSnASKd', caption: 'cat' } }
      let(:api_method) { 'sendPhoto' }

      it 'sends the user the front side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end

    context 'with a document' do
      let(:front_side_attrs) { { document_id: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:body_attrs) { { document: 'NjkanDKJSANDASjdnAKJDSnASKd' } }
      let(:api_method) { 'sendDocument' }

      it 'sends the user the front side of the card' do
        service.call
        expect(stub).to have_been_requested
      end
    end
  end
end

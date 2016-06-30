RSpec.describe AddCardFrontSide do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let!(:deck) { user.decks.create name: 'German 1000' }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { AddCardFrontSide.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"Got it! Now send me the back side."}.to_json
  }

  context 'receiving a text message' do
    let(:update_hash) {
      {:update_id=>321321,
        :message =>
        {:message_id=>38,
          :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
          :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
          :date=>1467277868,
          :text=>"Cat"}}
    }

    before do
      stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
        with(:body => {"chat_id"=>"1", "text"=>"Got it! Now send me the back side."}).
        and_return(status: 200, body: api_response)
        service.call
    end

    it 'changes the user status to adding_back_side' do
      expect(user).to be_adding_back_side
    end

    it 'creates a card with the given text' do
      expect(deck.cards.latest.first.front_side.text).to eq 'Cat'
    end
  end

  context 'receiving an image' do
    let(:update_hash) {
      {:update_id=>321321,
       :message=>
        {:message_id=>52,
         :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
         :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
         :date=>1467296123,
         :photo=>
          [{:file_id=>"AgADkgMT2qtkuAVEJhkABEIliFJDHOTDuKwBAAEC", :file_size=>1435, :width=>90, :height=>67},
           {:file_id=>"AgADkgMT2qtkuAVEJhkABFmihpGx-BE_uawBAAEC", :file_size=>18538, :width=>320, :height=>240},
           {:file_id=>"AgADkgMT2qtkuAVEJhkABMTAjtiqrp7Yt6wBAAEC", :file_size=>57195, :width=>600, :height=>450}]}}
    }

    before do
      stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
        with(:body => {"chat_id"=>"1", "text"=>"Got it! Now send me the back side."}).
        and_return(status: 200, body: api_response)
        service.call
    end

    it 'creates a card with the given image' do
      expect(deck.cards.latest.first.front_side.photo_id).to eq 'AgADkgMT2qtkuAVEJhkABEIliFJDHOTDuKwBAAEC'
    end

    context 'with caption' do
      let(:update_hash) {
        {:update_id=>321321,
         :message=>
          {:message_id=>52,
           :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
           :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
           :date=>1467296123,
           :caption => "a cat",
           :photo=>
            [{:file_id=>"AgADkgMT2qtkuAVEJhkABEIliFJDHOTDuKwBAAEC", :file_size=>1435, :width=>90, :height=>67},
             {:file_id=>"AgADkgMT2qtkuAVEJhkABFmihpGx-BE_uawBAAEC", :file_size=>18538, :width=>320, :height=>240},
             {:file_id=>"AgADkgMT2qtkuAVEJhkABMTAjtiqrp7Yt6wBAAEC", :file_size=>57195, :width=>600, :height=>450}]}}
      }

      it 'creates a card with the given image' do
        expect(deck.cards.latest.first.front_side.photo_id).to eq 'AgADkgMT2qtkuAVEJhkABEIliFJDHOTDuKwBAAEC'
      end

      it 'creates a card with the given caption' do
        expect(deck.cards.latest.first.front_side.text).to eq 'a cat'
      end

    end
  end

end

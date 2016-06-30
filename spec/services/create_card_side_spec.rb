RSpec.describe CreateCardSide do
  let(:service) { CreateCardSide.new(update) }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }

  context 'with a text message' do
    let(:update_hash) {
      {:update_id=>321321,
        :message=>
        {:message_id=>52,
          :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
          :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
          :date=>1467296123,
          :text => "a cat"}}
    }

    it 'creates a card side with the given text' do
      card_side = service.call
      expect(card_side.text).to eq 'a cat'
    end
  end

  context 'with a photo' do
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

    it 'creates a card side with the given photo' do
      card_side = service.call
      expect(card_side.photo_id).to eq 'AgADkgMT2qtkuAVEJhkABEIliFJDHOTDuKwBAAEC'
    end

    context 'with a caption' do
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

      it 'creates a card side with the given photo' do
        card_side = service.call
        expect(card_side.photo_id).to eq 'AgADkgMT2qtkuAVEJhkABEIliFJDHOTDuKwBAAEC'
      end

      it 'creates a card side with the given caption' do
        card_side = service.call
        expect(card_side.text).to eq 'a cat'
      end
    end

  end
end

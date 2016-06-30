RSpec.describe ProcessUpdate do
  let(:user) { User.create telegram_id: 1, first_name: 'Bob' }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { ProcessUpdate.new(user, update) }
  let(:update_hash) {
    {:update_id=>321321,
      :message=>
      {:message_id=>38,
        :from=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=> message_text,
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}}
  }

  context 'when the user is waiting' do
    context 'when the command is /newdeck' do
      let(:message_text) { '/newdeck' }

      it 'calls the AddDeck service' do
        expect_any_instance_of(AddDeck).to receive(:call)
        service.call
      end
    end

    context 'when the command is /practice' do
      let(:message_text) { '/practice'}

      it 'calls the ChooseDeckToPractice service' do
        expect_any_instance_of(ChooseDeckToPractice).to receive(:call)
        service.call
      end
    end
  end

  context 'when the user is adding_deck' do
    before { user.adding_deck! }
    let(:message_text) { 'German 1000' }

    context 'when it receives a message' do
      it 'calls the CreateDeck service' do
        expect_any_instance_of(CreateDeck).to receive(:call)
        service.call
      end
    end
  end

  context 'when the user is adding_front_side' do
    before { user.adding_front_side! }

    context 'when it receives the /done command' do
      let(:message_text) { '/done' }

      it 'calls the FinishAddingCards service' do
        expect_any_instance_of(FinishAddingCards).to receive(:call)
        service.call
      end
    end

    context 'when it receives any other message' do
      let(:message_text) { 'cat' }

      it 'calls the AddCardFrontSide service' do
        expect_any_instance_of(AddCardFrontSide).to receive(:call)
        service.call
      end
    end
  end

  context 'when the user is adding_back_side' do
    before { user.adding_back_side! }
    let(:message_text) { 'die Katze' }

    context 'when it receives the /done command' do
      let(:message_text) { '/done' }

      it 'calls the FinishAddingCards service' do
        expect_any_instance_of(FinishAddingCards).to receive(:call)
        service.call
      end
    end

    context 'when it receives a message' do
      it 'calls the AddCardBackSide service' do
        expect_any_instance_of(AddCardBackSide).to receive(:call)
        service.call
      end
    end
  end
end

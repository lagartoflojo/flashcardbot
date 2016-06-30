RSpec.describe ProcessUpdate do
  let(:user) { User.create telegram_id: 1, first_name: 'Bob' }
  let(:update_hash) {
    {:update_id=>321321,
      :message=>
      {:message_id=>38,
        :from=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>123123, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=>"/newdeck",
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { ProcessUpdate.new(user, update) }

  context 'when the user is waiting' do
    context 'when the command is /newdeck' do
      it 'calls the AddDeck service' do
        expect_any_instance_of(AddDeck).to receive(:call)
        service.call
      end
    end
  end
end

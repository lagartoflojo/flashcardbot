RSpec.describe AddDeck do
  let(:user) { User.create telegram_id: 123123, first_name: 'Bob' }
  let(:update_hash) {
    {:update_id=>321321,
      :message=>
      {:message_id=>38,
        :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
        :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
        :date=>1467277868,
        :text=>"/newdeck",
        :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}}
  }
  let(:update) { Telegram::Bot::Types::Update.new update_hash }
  let(:service) { AddDeck.new(user, update) }

  let(:api_response) {
    {:message_id=>38,
      :from=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"/newdeck",
      :entities=>[{:type=>"bot_command", :offset=>0, :length=>8}]}.to_json
  }

  it 'asks the user for the name of the deck' do
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
      with(:body => {"chat_id"=>"1", "text"=>"What’s the name of this deck?"}).
      and_return(status: 200, body: api_response)
    service.call
  end
end

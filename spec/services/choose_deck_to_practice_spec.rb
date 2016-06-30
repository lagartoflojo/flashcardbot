RSpec.describe ChooseDeckToPractice do
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
  let(:service) { ChooseDeckToPractice.new(user, update) }
  let(:api_response) {
    {:message_id=>39,
      :from=>{:id=>1, :first_name=>"Hippocardus", :username=>"hippocardus"},
      :chat=>{:id=>1, :first_name=>"Hernan", :last_name=>"Schmidt", :username=>"hernan", :type=>"private"},
      :date=>1467277868,
      :text=>"Choose the deck you want to practice."}.to_json
  }
  let!(:stub) {
    stub_request(:post, "https://api.telegram.org/bot#{Rails.application.secrets.bot_token}/sendMessage").
      with(:body => {"chat_id"=>"1", "reply_markup"=>/German 1000|Spanish 1000/, "text"=>"Choose the deck you want to practice."}).
      to_return(:status => 200, :body => api_response)
  }

  before do
    user.decks.create name: 'German 1000'
    user.decks.create name: 'Spanish 1000'
    service.call
  end

  it 'asks the user which deck she wants to practice' do
    expect(stub).to have_been_requested
  end

  it 'sets the user status to choosing_deck_to_practice' do
    expect(user).to be_choosing_deck_to_practice
  end
end

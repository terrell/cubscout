RSpec.describe Cubscout::Conversation do
  describe "#all" do
    it "gets all conversations" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations\?page\=*}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/conversations.json"))

      convos = Cubscout::Conversation.all

      expect(convos.size).to eq 6
      expect(convos.first.class).to eq Cubscout::Conversation
    end
  end
end

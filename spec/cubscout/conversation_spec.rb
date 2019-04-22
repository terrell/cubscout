RSpec.describe Cubscout::Conversation do
  describe ".all" do
    it "gets all conversations" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations\?page=*}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/conversations.json"))

      convos = Cubscout::Conversation.all

      expect(convos.size).to eq 6
      expect(convos.first.class).to eq Cubscout::Conversation
    end

    it "gets one page of conversations" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations\?page=1}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/conversations.json"))

      convos = Cubscout::Conversation.all(page: 1)

      expect(convos.size).to eq 2
    end

    it "gets a filtered list of conversations" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations\?page=1&status=active&tag=red,blue}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/conversations.json"))

      convos = Cubscout::Conversation.all(page: 1, status: "active", tag: "red,blue")

      expect(convos.size).to eq 2
    end
  end

  describe ".find" do
    it "gets one conversation" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations/\d+}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/conversation.json"))

      convo = Cubscout::Conversation.find(123)

      expect(convo.class).to eq Cubscout::Conversation
    end

    it "attributes are readable as both camel case and snake case" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations/\d+}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/conversation.json"))

      convo = Cubscout::Conversation.find(123)

      expect(convo.mailboxId).to eq 121212
      expect(convo.mailbox_id).to eq 121212
    end
  end

  describe ".threads" do
    it "gets the threads by conversation id" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations/\d+/threads}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/threads.json"))

      threads = Cubscout::Conversation.threads(123)

      expect(threads.size).to eq 3
      expect(threads.first.class).to eq Cubscout::Object
    end
  end

  describe ".create_note" do
    it "requires text" do
      expect { Cubscout::Conversation.create_note(123) }.to raise_exception ArgumentError
    end

    it "creates a text note on a conversation" do
      stub_request(:post, %r{https://api.helpscout.net/v2/conversations/\d+/notes}).
        to_return(status: 201)

      expect {
        Cubscout::Conversation.create_note(123, text: "new note")
      }.not_to raise_exception
    end
  end

  describe "#threads" do
    it "gets the threads of a conversation" do
      stub_request(:get, %r{https://api.helpscout.net/v2/conversations/\d+/threads}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/threads.json"))

      threads = Cubscout::Conversation.new(id: 123).threads

      expect(threads.size).to eq 3
      expect(threads.first.class).to eq Cubscout::Object
    end
  end

  describe "#create_note" do
    it "creates a text note on a conversation" do
      stub_request(:post, %r{https://api.helpscout.net/v2/conversations/\d+/notes}).
        to_return(status: 201)

      expect {
        Cubscout::Conversation.new(id: 123).create_note(text: "new note")
      }.not_to raise_exception
    end
  end

  describe "#assignee" do
    it "returns the user assigned to the conversation" do
      stub_request(:get, %r{https://api.helpscout.net/v2/users/\d+}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/user.json"))

      user = Cubscout::Conversation.new(id: 123, assignee: {id: 55667}).assignee

      expect(user.class).to eq Cubscout::User
    end
  end
end

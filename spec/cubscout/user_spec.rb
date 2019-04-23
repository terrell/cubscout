RSpec.describe Cubscout::User do
  describe ".all" do
    it "gets all users" do
      stub_request(:get, %r{https://api.helpscout.net/v2/users\?page=*}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/users.json"))

      users = Cubscout::User.all

      expect(users.size).to eq 6
      expect(users.first.class).to eq Cubscout::User
    end

    it "gets one page of users" do
      stub_request(:get, %r{https://api.helpscout.net/v2/users\?page=1}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/users.json"))

      users = Cubscout::User.all(page: 1)

      expect(users.size).to eq 3
    end

    it "gets a filtered list of users" do
      stub_request(:get, %r{https://api.helpscout.net/v2/users\?mailbox=121212&page=1}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/users.json"))

      users = Cubscout::User.all(page: 1, mailbox: 121212)

      expect(users.size).to eq 3
    end
  end

  describe ".find" do
    it "gets one user" do
      stub_request(:get, %r{https://api.helpscout.net/v2/users/\d+}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/user.json"))

      user = Cubscout::User.find(123)

      expect(user.class).to eq Cubscout::User
    end

    it "attributes are readable as both camel case and snake case" do
      stub_request(:get, %r{https://api.helpscout.net/v2/users/\d+}).
        to_return(status: 200, body: File.read("#{__dir__}/../support/user.json"))

      user = Cubscout::User.find(123)

      expect(user.firstName).to eq "Tim"
      expect(user.first_name).to eq "Tim"
    end
  end
end

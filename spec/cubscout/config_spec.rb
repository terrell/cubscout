RSpec.describe Cubscout::Config do
  it "mocks oauth_token" do
    expect(Cubscout::Config.oauth_token).to eq "123"
  end
end

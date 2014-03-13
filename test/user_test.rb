require "test_helper"
require "user"
require "couchbase_connection"

describe User do
  before do
    @user = User.find_or_create("me@example.com")
  end

  after do
    ["philipp.fehre@gmail.com", "me@example.com", "foobar"].each do |email|
      user = User.find(email)
      user.remove if user
    end
  end

  it "saves" do
    User.create("philipp.fehre@gmail.com").must_be_instance_of User
  end

  it "not saves twice" do
    User.create("philipp.fehre@gmail.com").must_be_instance_of User
    User.create("philipp.fehre@gmail.com").must_equal false
  end

  it "loads the user properties" do
    User.find("me@example.com").token.wont_be_empty
    User.find("me@example.com").email.wont_be_empty
  end

  it "finds user by token" do
    User.find_by_token(@user.token).email.wont_be_empty
  end

  it "finds or creates" do
    # new user
    User.find_or_create("philipp.fehre@gmail.com").token.wont_be_empty
    # existing user
    User.find_or_create("me@example.com").token.wont_be_empty
  end

  it "is does not save with an invalid email" do
    User.find_or_create("foobar").errors.wont_be_empty
  end
end

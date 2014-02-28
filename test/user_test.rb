require "test_helper"
require "user"
require "couchbase_connection"

describe User do
  before do
    @user = User.new("me@example.com")
    @user.save
  end

  after do
    User.new("philipp.fehre@gmail.com").remove
    User.new("me@example.com").remove
    User.new("foobar").remove
  end

  it "saves" do
    User.new("philipp.fehre@gmail.com").save.must_equal true
  end

  it "not saves twice" do
    User.new("philipp.fehre@gmail.com").save.must_equal true
    User.new("philipp.fehre@gmail.com").save.must_equal false
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

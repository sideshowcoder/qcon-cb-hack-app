require "test_helper"
require "user"
require "couchbase_connection"

describe User do
  before do
    User.new("me@example.com").save
  end

  after do
    db = CouchbaseConnection.connection

    db.delete "philipp.fehre@gmail.com" rescue nil
    db.delete "me@example.com" rescue nil
    db.delete "foobar" rescue nil
  end

  it "saves" do
    User.new("philipp.fehre@gmail.com").save.must_equal true
  end

  it "not saves twice" do
    User.new("philipp.fehre@gmail.com").save.must_equal true
    User.new("philipp.fehre@gmail.com").save.must_equal false
  end

  it "finds the user token" do
    User.find("me@example.com").token.wont_be_empty
  end

  it "finds or creates" do
    User.find_or_create("philipp.fehre@gmail.com").token.wont_be_empty
    User.find_or_create("me@example.com").token.wont_be_empty
  end

  it "is does not save with an invalid email" do
    User.find_or_create("foobar").errors.wont_be_empty
  end
end

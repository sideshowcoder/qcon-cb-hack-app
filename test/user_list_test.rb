require "test_helper"
require "user"
require "user_list"
require "couchbase_connection"

describe UserList do
  before do
    @user = User.create("me@example.com")
    @user2 = User.create("me2@example.com")
  end

  after do
    ["me@example.com", "me2@example.com"].each do |email|
      user = User.find(email)
      user.remove if user
    end
  end

  it "loads the users" do
    @users = UserList.all
    @users.wont_be_empty
    @users.first.email.must_equal "me@example.com"
  end
end


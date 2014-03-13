require "couchbase_connection"
require "user"

class UserList
  def self.all
    new.load_all
  end

  def load_all
    keys = user_keys.map(&:key)
    db.get(keys).map do |raw_user|
      User.new(email: raw_user["email"], token: raw_user["token"])
    end
  end

  private
  def user_keys
    CouchbaseConnection.users(stale: false)
  end

  def db
    CouchbaseConnection.connection
  end
end

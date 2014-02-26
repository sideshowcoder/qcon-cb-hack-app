require "couchbase_connection"
require "securerandom"
require "mail"

class User

  attr_reader :errors

  def self.find key
    new(key).load
  end

  def self.find_or_create key
    unless user = find(key)
      user = new(key)
      user.save
    end
    user
  end

  def initialize key
    @db = db
    @key = key
    @errors = []
  end

  def save
    return false unless valid?

    db.add @key, properties
    true
  rescue Couchbase::Error::KeyExists
    false
  end

  def token
    @token ||= SecureRandom.hex
  end

  def load
    return false unless valid?

    raw_user = db.get(@key)
    @token = raw_user["token"]
    self
  rescue Couchbase::Error::NotFound
    false
  end

  def valid?
    begin
      m = Mail::Address.new(@key)
      r = m.domain && m.address == @key
      t = m.__send__(:tree)
      r &&= (t.domain.dot_atom_text.elements.size > 1)
    rescue Exception
      r = false
    end
    @errors << "Email is invalid" unless r
    @errors.uniq!
    r
  end

  private

  def db
    @db ||= CouchbaseConnection.connection
  end

  def properties
    { email: @key, token: token }
  end
end

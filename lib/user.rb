require "couchbase_connection"
require "securerandom"
require "mail"

class User

  attr_reader :errors, :email, :key

  def self.find email
    new(email).load
  end

  def self.find_or_create email
    user = find(email)
    unless user
      user = new(email)
      user.save
    end
    user
  end

  def initialize email
    @db = db
    @email = email
    @key = "u::#{email}"
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
    @email = raw_user["email"]
    self
  rescue Couchbase::Error::NotFound
    false
  end

  def remove
    db.delete @key
  rescue Couchbase::Error::NotFound
    # if user is not stored anyway it's fine
    true
  end

  def valid?
    begin
      m = Mail::Address.new(@email)
      r = m.domain && m.address == @email
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
    { email: @email, token: token }
  end
end

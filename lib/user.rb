require "couchbase_connection"
require "securerandom"
require "mail"

class User

  attr_reader :errors, :email, :key

  def self.find email
    new(email).load
  end

  def self.find_by_token token
    new(nil, token).load
  end

  def self.find_or_create email
    user = find(email)
    unless user
      user = new(email)
      user.save
    end
    user
  end

  def initialize email, token = nil
    @db = db
    @email = email
    @key = "u::#{email}"
    @token = token
    @errors = []
  end

  def save
    return false unless valid?

    db.add @key, properties
    db.set token_key, @key
    true
  rescue Couchbase::Error::KeyExists
    false
  end

  def token
    @token ||= SecureRandom.hex
  end

  def load
    if email.nil?
      load_by_token
    else
      load_by_email
    end
  rescue Couchbase::Error::NotFound
    false
  end

  def remove
    begin
      db.delete @key
    rescue Couchbase::Error::NotFound
      # noop
    end
    begin
      db.delete token_key
    rescue Couchbase::Error::NotFound
      # if user is not stored anyway it's fine
      true
    end
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

  def load_by_token
    key = db.get(token_key)

    raw_user = db.get(key)
    @key = key
    @token = raw_user["token"]
    @email = raw_user["email"]

    self
  end

  def load_by_email
    return false unless valid?

    raw_user = db.get(@key)
    @token = raw_user["token"]
    @email = raw_user["email"]
    self
  end

  def token_key
    "t::#{@token}"
  end

  def db
    @db ||= CouchbaseConnection.connection
  end

  def properties
    { email: @email, token: token }
  end
end

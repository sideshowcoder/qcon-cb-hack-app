require "couchbase_connection"
require "securerandom"
require "sync_gateway_user"
require "mail"

class User

  attr_reader :errors, :email, :key

  def self.find email
    new(email: email).load
  end

  def self.create email
    if new(email: email).save
      find(email)
    else
      false
    end
  end

  def self.find_by_token token
    new(token: token).load
  end

  def self.find_or_create email
    user = find(email)
    unless user
      user = new(email: email)
      user.save
    end
    user
  end

  def initialize params
    @email = params[:email]
    @key = params.fetch(:key) { "u::#{email}" if @email }
    @token = params[:token]
    @completed = nil
    @errors = []
  end

  def save
    return false unless valid?

    db.add @key, properties
    db.set token_key, @key
    if SyncGatewayUser.new(self).register
      true
    else
      # roleback user creation
      self.remove
    end
  rescue Couchbase::Error::KeyExists
    false
  end

  def completed?
    if @completed.nil?
      doc = sync_gateway_bucket.get(token)
      # TODO more verification than 'it exists'
      @completed = !doc.empty?
    else
      @completed
    end
  rescue Couchbase::Error::NotFound
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
      # noop
    end
    SyncGatewayUser.new(self).deregister
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

    assign_properties db.get(key)
    @key = key
    self
  end

  def load_by_email
    return false unless valid?

    assign_properties db.get(@key)
    self
  end

  def assign_properties raw_user
    @token = raw_user["token"]
    @email = raw_user["email"]
  end


  def token_key
    "t::#{@token}"
  end

  def db
    @db ||= CouchbaseConnection.connection
  end

  def sync_gateway_bucket
    @sync_gateway_bucket ||= CouchbaseConnection.sync_gateway_bucket
  end

  def properties
    {
      email: @email,
      token: token,
    }
  end
end

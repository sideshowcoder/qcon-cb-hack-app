require "couchbase"

class CouchbaseConnection
  def self.connection
    @@connection ||= Couchbase.connect(ENV["COUCHBASE_URL"])
  end

  def self.sync_gateway_bucket
    @@sync_gateway_bucket ||= Couchbase.connect(ENV["SYNC_GATEWAY_COUCHBASE_URL"])
  end
end

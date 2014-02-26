require "couchbase"

class CouchbaseConnection
  def self.connection
    @@connection ||= Couchbase.connect(ENV["COUCHBASE_URL"])
  end
end

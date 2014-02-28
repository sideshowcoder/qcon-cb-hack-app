# Creating a new user in sync_gateway
#
# curl -XPOST localhost:4985/sync_gateway/_user/
# -d '{"name":"phil","admin_channels":["*"],
#      "all_channels":["*"],"password":"phil"}'
require "faraday"
require "json"

class SyncGatewayUser

  def initialize user
    @connection = Faraday.new(url: ENV["SYNC_GATEWAY_ADMIN_URL"]) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
    @user = user
  end

  def register
    result = @connection.post do |req|
      req.url '/sync_gateway/_user/'
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.dump(
        name: @user.email,
        admin_channels: [],
        all_channels: [@user.email],
        password: @user.token
      )
    end
    # either we created the user successfully or it was already present
    result.success? || result.status == 409
  end

  def deregister
    result = @connection.delete("/sync_gateway/_user/#{@user.email}")
    # either we remove the user or he was not present to begin with
    result.success? || result.status == 404
  end
end

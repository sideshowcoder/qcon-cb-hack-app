# Creating a new user in sync_gateway
#
# curl -XPOST localhost:4985/sync_gateway/_user/
# -d '{"name":"phil","admin_channels":["*"],
#      "all_channels":["*"],"password":"phil"}'

class SyncGatewayUser

  def initialize user
  end

  def register
  end

end

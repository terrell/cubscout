require "cubscout/version"
require "cubscout/config"

require "cubscout/resource"
require "cubscout/request"
require "cubscout/response"

require "cubscout/list"
require "cubscout/conversation"
require "cubscout/user"

module Cubscout
  class Error < StandardError; end

  class AuthenticationError < StandardError; end
  class InternalError < StandardError; end
  class InvalidFormatError < StandardError; end
  class JsonParseError < StandardError; end
  class MalformedRequestError < StandardError; end
  class PermissionDeniedError < StandardError; end
  class ResourceNotFoundError < StandardError; end
end

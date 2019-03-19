# frozen_string_literal: true

require "json"

module Cubscout
  class Response < Faraday::Response::Middleware
    def on_complete(env)
      handle_response_status(env.status, env.body)
      parse_json_reponse(env) unless env.status == 204
    end

    private

    def handle_response_status(status, body)
      case status
      when 400
        raise Cubscout::MalformedRequestError, body
      when 401
        raise Cubscout::AuthenticationError, body
      when 403
        raise Cubscout::PermissionDeniedError, body
      when 404
        raise Cubscout::ResourceNotFoundError, body
      when 500
        raise Cubscout::InternalError, body
      end
    end

    def parse_json_reponse(env)
      begin
        parsed_body = JSON.parse(env.body)
        env[:raw_body] = env.body
      rescue JSON::ParserError
        raise Cubscout::JsonParseError, env.body
      end

      env.body = parsed_body
    end

  end
end

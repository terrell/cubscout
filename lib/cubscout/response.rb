# frozen_string_literal: true

require "json"

module Cubscout
  class Response < Faraday::Response::Middleware
    def on_complete(env)
      handle_response_status(env.status, env)
      parse_json_reponse(env)
    end

    private

    def handle_response_status(status, env)
      case status
      when 400
        raise Cubscout::MalformedRequestError, env.body
      when 401
        raise Cubscout::AuthenticationError, env.body
      when 403
        raise Cubscout::PermissionDeniedError, env.body
      when 404
        raise Cubscout::ResourceNotFoundError, env.body
      when 429
        limit = env.response_headers["x-ratelimit-limit-minute"]
        remaining = env.response_headers["x-ratelimit-remaining-minute"]
        retry_after = env.response_headers["x-ratelimit-retry-after"]
        raise Cubscout::RateLimitExceeded, {retry_after_minutes: retry_after, limit: limit, remaining: remaining}
      when 500
        raise Cubscout::InternalError, env.body
      end
    end

    def parse_json_reponse(env)
      return true if [201, 204].include?(env.status)

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

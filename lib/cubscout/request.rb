# frozen_string_literal: true

module Cubscout
  class Request < Faraday:: Middleware
    def call(env)
      env.request_headers['Authorization'] = "Bearer #{Config.oauth_token}"
      env.request_headers['Content-Type'] = 'application/json'
      env.request_headers['Accept'] = 'application/json'

      @app.call(env)
    end
  end
end

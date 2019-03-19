# frozen_string_literal: true

require 'faraday'

module Cubscout
  class << self
    def connection
      @connection ||= Faraday.new(url: Cubscout::Config.api_prefix) do |faraday|
        faraday.use Cubscout::Request
        faraday.use Cubscout::Response
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end

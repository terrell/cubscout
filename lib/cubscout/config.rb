# frozen_string_literal: true

require "oauth2"

module Cubscout
  DEFAULT_API_PREFIX = 'https://api.helpscout.net/v2'

  class Config
    class << self
      attr_writer :api_prefix, :client_id, :client_secret

      def api_prefix
        @api_prefix ||= DEFAULT_API_PREFIX
      end

      def reset!
        @client_id = @client_secret = @access_token = nil
        @access_token = @oauth_client = nil
        @api_prefix = DEFAULT_API_PREFIX
      end

      def oauth_token
        access_token.token
      end

      private

      def access_token
        if @access_token && @access_token.expires_at > Time.now.to_i + 30
          return @access_token
        end

        @access_token = oauth_client.client_credentials.get_token
      end

      def oauth_client
        @oauth_client ||= OAuth2::Client.new(@client_id, @client_secret, site: api_prefix, token_url: '/oauth2/token')
      end
    end
  end
end

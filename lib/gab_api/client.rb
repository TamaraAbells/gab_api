# frozen_string_literal: true

require 'singleton'
require 'faraday'
require 'multi_json'

module GabApi
  class MissingAccessToken < RuntimeError; end
  class Client
    include Singleton

    BASE_URL = 'https://api.gab.com'

    # rubocop:disable Style/ClassVars
    @@access_token = nil

    attr_reader :conn

    class << self
      def access_token=(token)
        @@access_token = token
      end
    end
    # rubocop:enable Style/ClassVars

    def initialize
      if @@access_token.nil?
        fail MissingAccessToken, 'Did you forget to set your GabApi::Client.access_token = yourauthtoken'
      end
      @conn = Faraday.new(url: BASE_URL) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers[:user_agent] = "GabApi v#{VERSION}; Ruby Gem: github.com/midwire/gab_api"
      end
    end

    def get(path, data_hash = nil)
      resp = conn.get do |req|
        req.url path
        headers(req)
        req.body = MultiJson.dump(data_hash) if data_hash
      end
      build_response(resp)
    end

    def post(path, data_hash = nil)
      resp = conn.post do |req|
        req.url path
        headers(req)
        req.body = MultiJson.dump(data_hash) if data_hash
      end
      build_response(resp)
    end

    private

    def json_to_hash(json)
      MultiJson.load(json, symbolize_keys: true)
    end

    def headers(request)
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{@@access_token}"
    end

    # Build an array of [status, body]
    #
    # @param resp [Response] describe_resp_here
    # @return [Type] description_of_returned_object
    def build_response(resp)
      response = [resp.status]
      response << if resp.success?
                    json_to_hash(resp.body)
                  else
                    resp.reason_phrase
                  end
      response
    end
  end
end

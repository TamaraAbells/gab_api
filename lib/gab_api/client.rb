# frozen_string_literal: true

require 'singleton'
require 'faraday'
require 'multi_json'

module GabApi
  class MissingAccessToken < RuntimeError; end
  class Client
    include Singleton

    BASE_URL = 'https://api.gab.com'

    @@access_token = nil

    attr_reader :conn

    class << self
      def access_token=(token)
        @@access_token = token
      end
    end

    def initialize
      if @@access_token.nil?
        fail MissingAccessToken, 'Did you forget to set your GabApi::Client.access_token = yourauthtoken'
      end
      @conn = Faraday.new(url: BASE_URL) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, data_hash = nil)
      resp = conn.get do |req|
        req.url path
        headers(req)
        req.body = MultiJson.dump(data_hash) if data_hash
      end
      return [resp.status, resp.reason_phrase] unless resp.success?
      json_to_hash(resp.body)
    end

    def post(path, data_hash = nil)
      resp = conn.post do |req|
        req.url path
        headers(req)
        req.body = MultiJson.dump(data_hash) if data_hash
      end
      return [resp.status, resp.reason_phrase] unless resp.success?
      json_to_hash(resp.body)
    end

    private

    def json_to_hash(json)
      MultiJson.load(json, symbolize_keys: true)
    end

    def headers(request)
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{@@access_token}"
    end
  end
end

# frozen_string_literal: true

module GabApi
  class User
    class << self
      def me
        client = Client.instance
        data = client.get('/v1.0/me')
        new(data)
      end

      def find(username)
        client = Client.instance
        data = client.get("/v1.0/users/#{username}")
        binding.pry
        new(data)
      end
    end

    def initialize(data)
      @data = data
    end

    # Magic attributes
    def method_missing(method, *args, &block)
      return @data.dig(method) if @data.key?(method)
      super
    end

    def respond_to_missing?(method, _include_private = false)
      return false unless @data.key?(method)
      super
    end
  end
end

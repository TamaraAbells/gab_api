# frozen_string_literal: true

module GabApi
  class ObjectBase
    attr_reader :client

    class << self
      private

      def instantiate(status, data)
        fail TransactionalError.new([status, data]) unless status == 200
        new(data)
      end
    end

    # Magic attributes
    def method_missing(method, *args, &block)
      return @attributes.dig(method) if @attributes.key?(method)
      super
    end

    def respond_to_missing?(method, _include_private = false)
      return false unless @attributes.key?(method)
      super
    end

    private

    def initialize(attributes)
      @attributes = attributes
    end
  end
end

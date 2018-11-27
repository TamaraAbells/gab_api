# frozen_string_literal: true

module GabApi
  class TransactionalError < RuntimeError
    attr_reader :response

    def initialize(response, extra_message = nil)
      @response = response
      msg_parts = ["Status: #{response.first} - #{response.last}"]
      msg_parts << ": #{extra_message}" unless extra_message.nil?
      super(msg_parts.join)
    end
  end
end

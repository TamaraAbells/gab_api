# frozen_string_literal: true

module GabApi
  class Feed < ObjectBase
    class << self
      # Retrieve the latest 28 posts from the current user's feed
      #
      # @return [Type] description_of_returned_object
      def latest
        client = Client.instance
        status, data_hash = client.get('/v1.0/feed')
        fail TransactionalError.new([status, data_hash]) unless status == 200
        collection = []
        data_hash[:data].each do |attributes|
          collection << Post.new(attributes)
        end
        collection
      end
    end
  end
end

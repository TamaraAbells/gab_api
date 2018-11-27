# frozen_string_literal: true

module GabApi
  class Notification < ObjectBase
    class << self
      # Retrieve the latest notifications for the current user
      #
      # @return [Type] description_of_returned_object
      def latest
        client = Client.instance
        status, data_hash = client.get('/v1.0/notifications')
        fail TransactionalError.new([status, data_hash]) unless status == 200
        collection = []
        data_hash[:data].each do |attributes|
          collection << Notification.new(attributes)
        end
        collection
      end
    end
  end
end

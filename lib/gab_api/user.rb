# frozen_string_literal: true

module GabApi
  class User < ObjectBase
    class << self
      # Find the logged-in user represented by the oauth code passed to the Client in an earlier call
      # and return the User object.
      #
      # @param username [String] Gab username
      # @return [User] A user instance
      def me(stubbed_client = nil)
        client = stubbed_client || Client.instance
        status, data = client.get('/v1.0/me')
        instantiate(status, data)
      end

      # Find the user by the passed username and instantiate a User object with the found data
      #
      # @param username [String] Gab username
      # @return [User] A user instance
      def find(username)
        client = Client.instance
        status, data = client.get("/v1.0/users/#{username}")
        instantiate(status, data)
      end
    end

    # Retreive a collection of users that follow this user
    #
    # @param refresh [Boolean] default: false - Refresh the list instead of returning the
    #   cached collection
    # @return [Array] List of User objects
    def followers(refresh = false)
      unless refresh
        @followers_array ||= []
        return @followers_array if @followers_array.any?
      end
      @followers_array = assocated_users(:followers)
    end

    # Retreive a collection of users followed by this user
    #
    # @param refresh [Boolean] default: false - Refresh the list instead of returning the
    #   cached collection
    # @return [Array] List of User objects
    def following(refresh = false)
      @following_array ||= []
      unless refresh
        return @following_array if @following_array.any?
      end
      @following_array = assocated_users(:followers)
    end

    # Return whether the passed user is a follower or not.
    #
    # @param user_or_id [User|Integer] The ID of a user or a User instance
    # @return [Boolean] true if the passed user is a follower, false if not
    def follower?(user_or_id)
      id = user_or_id.respond_to?(:id) ? user_or_id.id : user_or_id
      @followers_array.any? { |e| e.id == id }
    end

    # Return whether this user is following the passed user
    #
    # @param user_or_id [User|Integer] The ID of a user or a User instance
    # @return [Type] description_of_returned_object
    def following?(user_or_id)
      id = user_or_id.respond_to?(:id) ? user_or_id.id : user_or_id
      @following_array.any? { |e| e.id == id }
    end

    private

    def assocated_users(following_or_followers)
      collection = []
      skip = 0
      _status, response = send(assocation_method_sym(following_or_followers), skip)
      until response[:data].count.zero?
        response[:data].each do |attributes|
          collection << User.new(attributes)
        end
        sleep 1
        skip += response[:data].count
        _status, response = send(assocation_method_sym(following_or_followers), skip)
      end
      collection
    end

    def assocation_method_sym(following_or_followers)
      {
        followers: :next_batch_of_followers,
        following: :next_batch_of_following
      }[following_or_followers.to_sym]
    end

    def next_batch_of_followers(skip)
      Client.instance.get("/v1.0/users/#{username}/followers?before=#{skip}")
    end

    def next_batch_of_following(skip)
      Client.instance.get("/v1.0/users/#{username}/following?before=#{skip}")
    end
  end
end

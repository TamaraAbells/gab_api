# frozen_string_literal: true

require 'spec_helper'

module GabApi
  RSpec.describe Client, type: :lib, vcr: true do
    subject(:client) do
      Client.access_token = ENV['GAB_OAUTH_TOKEN']
      Client.instance
    end

    it 'raises an error if access token is not set' do
      expect do
        Client.access_token = nil
        Client.instance
      end.to raise_error(MissingAccessToken)
    end

    it 'does not allow .new to be called' do
      expect do
        Client.new
      end.to raise_error(NoMethodError)
    end

    context '#get' do
      it 'gets current user details' do
        data = client.get('/v1.0/me')
        expect(data).to be_a(Hash)
        expect(data[:id]).to be_a(Integer)
        expect(data[:name]).to be_a(String)
      end
    end

    context '#post' do
      it 'successfully creates a post' do
        data = {
          body: 'This is a test post from gab_api Ruby gem, currently in development.',
          gif: 'gw3IWyGkC0rsazTi'
        }
        client.post('/v1.0/posts', data)
      end
    end
  end
end

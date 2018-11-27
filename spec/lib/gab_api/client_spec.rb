# frozen_string_literal: true

require 'spec_helper'

module GabApi
  RSpec.describe Client, type: :lib, vcr: true do
    let(:client) { Client.instance }

    it 'does not allow .new to be called' do
      expect do
        Client.new
      end.to raise_error(NoMethodError)
    end

    context '#get' do
      it 'gets current user details' do
        status, body = client.get('/v1.0/me')
        expect(status).to eq(200)
        expect(body[:id]).to be_a(Integer)
        expect(body[:name]).to be_a(String)
      end
    end

    context '#post' do
      it 'successfully creates a post' do
        post_data = {
          body: 'This is a test post from gab_api Ruby gem, currently in development.',
          gif: 'gw3IWyGkC0rsazTi'
        }
        status, body = client.post('/v1.0/posts', post_data)
        expect(status).to eq(200)
        expect(body[:id]).to_not be_empty
        expect(body[:type]).to eq('post')
      end
    end
  end
end

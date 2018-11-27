# frozen_string_literal: true

require 'spec_helper'

module GabApi
  RSpec.describe User, type: :lib, vcr: true do
    let(:client) { Client.instance }
    let(:user_attributes) do
      %i[
        id name username created_at_month_label bio follower_count following_count post_count cover_url
        picture_url picture_url_full following followed verified is_pro is_donor is_investor is_premium
        is_tippable is_private is_accessible follow_pending score video_count is_favorited subscribing
        is_muted distribution
      ]
    end

    context '#me' do
      it 'retrieves current user' do
        user = User.me
        user_attributes.each do |attrib|
          expect(user.send(attrib)).to_not be_nil
        end
      end

      it 'raises an error on failure' do
        expect(client).to receive(:get).and_return([400, 'Bad Request'])
        expect do
          User.me(client)
        end.to raise_error(TransactionalError)
      end
    end

    context '#find' do
      it 'retrieves an existing user' do
        user = User.find('support')
        expect(user.username).to eq('support')
      end
    end

    context '#followers' do
      it 'returns the followers for the user' do
        user = User.me
        followers = user.followers
        expect(followers.first).to be_a(User)
      end
    end

    context '#following' do
      it 'returns the following for the user' do
        user = User.me
        following = user.following
        expect(following.first).to be_a(User)
      end
    end
  end
end

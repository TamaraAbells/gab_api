# frozen_string_literal: true

require 'spec_helper'

module GabApi
  RSpec.describe User, type: :lib, vcr: true do
    let!(:client) do
      Client.access_token = ENV['GAB_OAUTH_TOKEN']
      Client.instance
    end
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
    end

    context '#find' do
      it 'retrieves an existing user', focus: true do
        user = User.find('a')
        user_attributes.each do |attrib|
          expect(user.send(attrib)).to_not be_nil
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

module GabApi
  RSpec.describe Feed, type: :lib, vcr: true do
    context '#latest' do
      it 'retrieves a collection of posts' do
        posts = Feed.latest
        expect(posts.count).to be_positive
        expect(posts.first).to be_a(Post)
      end
    end
  end
end

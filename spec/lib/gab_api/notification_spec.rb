# frozen_string_literal: true

require 'spec_helper'

module GabApi
  RSpec.describe Notification, type: :lib, vcr: true do
    context '#latest' do
      it 'returns a collection of notifications' do
        notifications = Notification.latest
        expect(notifications.count).to be_positive
        expect(notifications.first).to be_a(Notification)
      end
    end
  end
end

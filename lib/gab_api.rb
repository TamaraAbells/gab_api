# frozen_string_literal: true

require 'gab_api/version'
require 'gab_api/errors'
require 'gab_api/object_base'

module GabApi
  def self.root
    Pathname.new(File.dirname(__FILE__)).parent
  end

  autoload :Client, 'gab_api/client'
  autoload :Feed, 'gab_api/feed'
  autoload :Post, 'gab_api/post'
  autoload :User, 'gab_api/user'
  autoload :Notification, 'gab_api/notification'
end

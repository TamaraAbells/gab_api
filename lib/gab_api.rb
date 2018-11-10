# frozen_string_literal: true

require 'gab_api/version'

module GabApi
  def self.root
    Pathname.new(File.dirname(__FILE__)).parent
  end

  autoload :Client, 'gab_api/client'
  autoload :User, 'gab_api/user'
end

require 'dm-core'
require 'grit'
require 'json'
require 'fileutils'
require 'simple_uuid'

require 'dm-git-adapter/helpers'
require 'dm-git-adapter/adapter'
require 'dm-git-adapter/git_resource'

module DataMapper
  module Adapters
    class GitAdapter < AbstractAdapter

      VERSION = "0.0.0alpha0"

    end
  end
end

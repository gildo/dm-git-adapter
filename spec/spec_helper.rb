require 'rubygems'
require 'rspec'
require 'dm-git-adapter'
require 'dm-core'

require 'dm-core/spec/lib/pending_helpers'

RSpec.configure do |config|
    config.include(DataMapper::Spec::PendingHelpers)
end

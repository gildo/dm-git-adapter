require File.dirname(__FILE__) + '/spec_helper'
require 'dm-core/spec/shared/adapter_spec'

describe 'DataMapper::Adapters::GitAdapter' do
  before :all do
    @adapter = DataMapper.setup(:default, :adapter => 'git',
                                :hostname => 'localhost',
                                :database => 'dm-git-adapter')
    end

    it_should_behave_like 'An Adapter'
end

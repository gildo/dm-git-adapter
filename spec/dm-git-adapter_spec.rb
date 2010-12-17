require File.dirname(__FILE__) + '/spec_helper'
require 'dm-core/spec/shared/adapter_spec'

ENV['ADAPTER'] = 'git'

describe 'DataMapper::Adapters::GitAdapter' do

  before :all do
    @adapter = DataMapper.setup(:default, :adapter => 'git',
                                :repository => '/tmp/git-dm-data')
  end

  it_should_behave_like 'An Adapter'
end

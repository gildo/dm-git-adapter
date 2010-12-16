require 'dm-core'
require 'dm-core/adapters/abstract_adapter' 
require 'json'
require 'grit'

module DataMapper::Adapters

  class GitAdapter < AbstractAdapter
    mattr_accessor :db_root
    
    self.db_root = './git-data'

    def initialize(name, options)
      super                                       # 3

      @options[:database] ||= GitAdapter.db_root
      @repo = Grit::Repo.new                              
    end

    def create(resources)
      update_records(resources.first.model) do |records|
        resources.each do |resource|
          initialize_serial(resource, records.size.succ)
          records << attributes_as_fields(resource.attributes(nil))
        end
      end
    end

  end
end

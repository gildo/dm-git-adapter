require 'dm-core'
require 'grit'
require 'json'

module DataMapper
  module Adapters
    class GitAdapter < AbstractAdapter

      attr_accessor :repository, :default_branch, :git_user_name, :git_user_email

      #self.default_branch = 'master'

      
      def initialize(name, options)
        super

        @repository = @options[:repository] || '/tmp/dm-git-data'
        @repo = Grit::Repo.new(@repository)
      end

      def execute(&block)
        self.index = Grit::Index.new(@repository)
        yield self
      end

      def serialize(resource)
        resource.attributes(:field).to_json
      end

      def create(resources)
        #LOL db_subdir id LOL
        dir = File.join(self.class.db_subdir, self.id)
        
        result = execute do |resource|
          resource.index.add(File.join(dir, 'attributes.json'), serialize(resource))
        end

        return result
      end
    end
  end
end

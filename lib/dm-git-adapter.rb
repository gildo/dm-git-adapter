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

      def self.last_commit(branch = nil)
        branch ||= default_branch
        return nil unless repo.commits(branch).any?
        GitModel.repo.commits("#{branch}^..#{branch}").first || GitModel.repo.commits(branch).first
      end
      
      def self.current_tree(branch = nil)
        c = last_commit(branch)
        c ? c.tree : nil
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
        
        execute do |resource|
          resource.index.add(File.join(dir, 'attributes.json'), serialize(resource))
        end
      end

      def read (query)
        object = self.current_tree / File.join(dir, 'attributes.json')
        attributes = JSON.parse(object.data, :max_nesting => false)
        query.filter_records(attributes)
      end

      def update(attributes, collection)
        attributes = attributes_as_fields(attributes)
        execute do
          collection.each do |resource|
            attributes = resource.attributes(:field).merge(attributes)
            resource.index.add(File.join(dir, 'attributes.json'), serialize(resource))
          end
        end

      end

    end
  end
end

require 'dm-core'
require 'grit'
require 'json'

module DataMapper
  module Adapters
    class GitAdapter < AbstractAdapter

      attr_accessor :path

      default_branch = 'master'
            
      def self.create_db!
        raise "Database #{@path} already exists!" if File.exist? @path
          if @path =~ /.+\.git/
            Grit::Repo.init_bare @path
          else
            Grit::Repo.init @path 
          end
      end

      def initialize(name, options)
        super

        @path = @options[:path] || '/tmp/dm-git-data'
      end
      
      def repo
        repo = Grit::Repo.new(@path)
      end

      def execute(&block)
        def self.index; Grit::Index.new(repo);end
        yield self
      end

      def serialize(resource)
         attributes_as_fields(resource.attributes(nil))
      end

      def create(resources)
        execute do |t|
          resources.each do |resource|
            initialize_serial(resource, rand(2**32))
            attributes = serialize(resource)
            t.index.add(File.join(resource.class.storage_name.to_s, 'attributes.json'), attributes.to_json)
          end
        end
      end
    end
  end
end

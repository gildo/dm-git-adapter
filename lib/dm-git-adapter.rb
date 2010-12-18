require 'dm-core'
require 'grit'
require 'json'

module DataMapper
  module Adapters
    class GitAdapter < AbstractAdapter

      attr_accessor :path
      attr_accessor :index, :repo
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
        @repo = Grit::Repo.new(@path)
      end
        
      def last_commit(branch = nil)
        branch ||= "master"
        return nil unless @repo.commits(branch).any?
        @repo.commits("#{branch}^..#{branch}").first || @repo.commits(branch).first
       end

     
      def execute(&block)
        self.index = Grit::Index.new(@repo)
        parent = @repo.commits.last
        index.read_tree(parent.to_s)
        yield self
        committer = Grit::Actor.new("fyskij", "fiorito.g@gmail.com")
        sha = index.commit("lol", parent ? [parent] : nil, committer, nil, "master")
      end

      def create(resources)
        execute do |t|
          resources.each do |resource|
            initialize_serial(resource, rand(2**32))
            t.index.add(File.join(resource.class.storage_name.to_s, 'attributes.json'), resource.attributes(:field).to_json)
          end
        end
      end
    end
  end
end

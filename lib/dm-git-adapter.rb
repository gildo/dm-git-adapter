require 'dm-core'
require 'grit'
require 'json'
require 'pathname'
require Pathname(__FILE__).dirname + 'dm-git-adapter/adapter'

module DataMapper
  module Adapters
    class GitAdapter < AbstractAdapter

      attr_accessor :path, :index, :repo, :attributes

      def self.create_db!
        raise "Database #{@path} already exists!" if File.exist? @path
        if @path =~ /.+\.git/
          Grit::Repo.init_bare @path
        else
        end
      end

      def last_commit(branch = "master")
        branch = "master"
        return nil unless @repo.commits(branch).any?
        @repo.commits("#{branch}^..#{branch}").first || @repo.commits(branch).first
      end

      def execute(&block)
        if index
          yield self
        else
          parent = last_commit
          self.index = Grit::Index.new(@repo)

          index.read_tree(parent.to_s)
          yield self
          committer = Grit::Actor.new("fyskij", "fiorito.g@gmail.com")
          sha = index.commit("lol", nil, committer, nil, "master")
          return sha
        end
      end

      def current_tree(branch = nil)
        c = last_commit(branch)
        c ? c.tree : nil
      end

    end
    const_added(:GitAdapter)
  end
end

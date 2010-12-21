module DataMapper::Adapters
  class GitAdapter < AbstractAdapter
    attr_accessor :path, :index

    include Helpers

    def initialize(name, options)
      super

      @path = @options[:path] || '/tmp/dm-git-data'
      File.exists?(@path)? self : create_db!
      @repo = Grit::Repo.new(@path)
    end

    def create(resources)
      execute do |t|
        resources.each do |resource|
          resource.id.nil?? resource[:id] = SimpleUUID::UUID.new.to_guid : self
          t.index.add(File.join("#{resource.class.storage_name.to_s}", "#{resource.id.to_s}", "attributes.json"), JSON.pretty_generate(resource.attributes))
        end
      end
    end
  end

  const_added(:GitAdapter)
end

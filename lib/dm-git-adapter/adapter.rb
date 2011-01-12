module DataMapper::Adapters
  class GitAdapter < AbstractAdapter
    attr_accessor :path, :index, :attrs

    include Helpers

    def initialize(name, options)
      super

      @path = @options[:path] || '/tmp/dm-git-data'
      File.exists?(@path)? self : create_db!
      @repo = Grit::Repo.new(@path)
    end

    def create(resources)
      resources.each do |resource|
        write_records(resources.first.model, resource.attributes) do |t|
          #initialize_serial(resource, t.attrs.size.succ)
          t.index.add(File.join(resource.class.storage_name.to_s, "attributes.json"), JSON.pretty_generate(resource.attributes))
        end
      end
    end

    def read(query)
      #object = records_for(query.model.storage_name.to_s)
      #puts object
      query.filter_records(records_for(query.model.storage_name).dup)
    end
  end

  const_added(:GitAdapter)
end

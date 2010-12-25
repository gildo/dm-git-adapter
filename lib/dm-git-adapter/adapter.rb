module DataMapper::Adapters
  class GitAdapter < AbstractAdapter
    attr_accessor :path, :index, :records

    include Helpers

    def initialize(name, options)
      super

      @path = @options[:path] || '/tmp/dm-git-data'
      File.exists?(@path)? self : create_db!
      @repo = Grit::Repo.new(@path)
    end

    def create(resources)
      resources.each do |resource|
        puts resource.attributes
        write_records(resources.first.model, resource.attributes) do |t|
          initialize_serial(resource, t.records.size.succ)
          t.index.add(File.join(resource.class.storage_name.to_s, resource.id.to_s, "attributes.json"), JSON.pretty_generate(resource.attributes))
        end
      end
      keys_for(resources.first.model)
    end
    
    def read(query)
      results = []
      dirs = (current_tree / query.model.storage_name.to_s).trees
      dirs.each do |dir|
        o = self.class.new
        o.send :loads, File.join(query.model.storage_name.to_s, dir.name)
        results << o
        query.filter_records(results)
      end
    end

    def loads(dir)
      object = current_tree / File.join(dir, 'attributes.json')
      JSON.parse(object.data, :max_nesting => false)
    end

  end

  const_added(:GitAdapter)
end

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
    end
    
    def read(query)
      object = File.join("#{query.model.storage_name.to_s}", "#{}", 'attributes.json')
      attributes = JSON.parse(File.open(object).read)
      query.filter_records(attributes)
    end

  end

  const_added(:GitAdapter)
end

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
      execute(resources.first.model) do |records|
        resources.each do |resource|
          initialize_serial(resource, records.size.succ)
          rec = attributes_as_fields(resource.attributes(nil))
          index.add(json_file(resources.first.model), JSON.pretty_generate(rec))
        end
      end
    end

    def read(query)
      object = File.join("#{query.model.storage_name.to_s}", 'attributes.json')
      attributes = JSON.parse(File.open(object).read)
      query.filter_records(attributes)
    end

  end

  const_added(:GitAdapter)
end

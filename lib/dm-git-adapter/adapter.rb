module DataMapper::Adapters
  class GitAdapter < AbstractAdapter

    def initialize(name, options)
      super

      @path = @options[:path] || '/tmp/dm-git-data'
      File.exists?? self : create_db!
      @repo = Grit::Repo.new(@path)
    end

    def create(resources)
      execute do |t|
        resources.each do |resource|
          respath = "#{resource.class.storage_name.to_s}"
          FileUtils.mkdir(respath)
          t.index.add(File.join("#{respath}", 'attributes.json'), JSON.pretty_generate(resource.attributes))
        end
      end
    end
  end
end

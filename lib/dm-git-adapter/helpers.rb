module Helpers

  def create_db!
    raise "Database #{@path} already exists!" if File.exist? @path
    Grit::Repo.init @path
  end
  
  def last_c
    @repo.commits("master^..master").first || @repo.commits("master").first
  end

  def current_tree
    c = last_c
    c ? c.tree : nil
  end

  def json_file(model)
    current_tree / File.join("#{model}","attributes.json")
  end

  def records_for(model)
    file = json_file(model).data
    JSON.parse(file).dup || []
  end

  def write_records(model, attrs, &block)
    parent = last_c
    self.index = Grit::Index.new(@repo)
    index.read_tree(parent.to_s)
    yield self
    committer = Grit::Actor.new("fyskij", "fiorito.g@gmail.com")
    index.commit("lol", nil, committer, nil, "master")
  end

end

module Helpers

  def create_db!
    raise "Database #{@path} already exists!" if File.exist? @path
    Grit::Repo.init @path
  end

  def last_commit(branch = "master")
    @repo.commits("#{branch}").first || @repo.commits(branch).first
  end


  def current_tree(branch = nil)
    c = last_commit(branch)
    c ? c.tree : nil
  end

  def json_file(model)
    File.join("#{@path}/#{model.storage_name(name)}","attributes.json")
  end

  def records_for(model)
    file = json_file(model)
    File.readable?(file) && JSON.parse(File.read(file)) || []
  end

  def write_records(model, records, &block)
    parent = last_commit
    self.index = Grit::Index.new(@repo)
    index.read_tree(parent.to_s)
    self.records = records_for(model)
    yield self
    committer = Grit::Actor.new("fyskij", "fiorito.g@gmail.com")
    index.commit("lol", nil, committer, nil, "master")
  end

end

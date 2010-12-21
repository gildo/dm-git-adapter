module Helpers

  def create_db!
    raise "Database #{@path} already exists!" if File.exist? @path
    Grit::Repo.init @path
  end

  def last_commit(branch = "master")
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
      index.commit("lol", nil, committer, nil, "master")

    end
  end

  def current_tree(branch = nil)
    c = last_commit(branch)
    c ? c.tree : nil
  end

  def id
    @id
  end

  def id=(string)
    # TODO ensure is valid as a filename
    @id = string
  end

end

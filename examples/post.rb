$LOAD_PATH.unshift 'lib'
require 'dm-git-adapter'

class Post
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :title,      String    # A varchar type string, for short strings
  property :body,       Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
end

DataMapper.setup(:default, 'git:///tmp/dm-git-data')

DataMapper.finalize

@post = Post.create(
  :title      => "My SectaMapper post",
  :body       => "A lot fewtext ...",
  :created_at => Time.now
)
@post.save!

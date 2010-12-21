Gem::Specification.new do |s|

  s.name = "dm-git-adapter"
  s.version = "0.0.0"
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = "A Git Adapter for Datamapper"
  s.homepage = "http://github.com/fyskij/dm-git-adapter"
  s.email = "fiorito.g@gmail.com"
  s.authors = [ "Ermenegildo Fiorito" ]
  s.has_rdoc = false
  s.files = %w( README.md )
  s.files += Dir.glob("lib/**/*")
  s.post_install_message = <<-message

...of this astounding life down here
and of the strange clowns in control of it

-L. F.


message

  s.add_dependency('dm-core')
  s.add_dependency('simple_uuid')


end



module DataMapper
  module GitResource

    def self.included(mod)
      mod.class_eval do
        include DataMapper::Resource

        property :id, Serial, :key => false
      end
    end
  end
end

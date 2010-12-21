module DataMapper
  module GitResource

    def self.included(mod)
      mod.class_eval do
        include DataMapper::Resource

        property :id, String, :key => true
      end
    end
  end
end

module DataMapper
  module GitResource

    def self.included(mod)
      mod.class_eval do
        include DataMapper::Resource

        property :id, Serial, :key => true, :default => Proc.new { SimpleUUID::UUID.new.to_guid }
      end
    end
  end
end

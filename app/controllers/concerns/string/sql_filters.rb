module Concerns::String::SqlFilters
    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        define_class_methods(source)
    end

    def define_class_methods(source = self)
        #returns true if input string does not follow pattern of: Modelname or Modelname.find/where/order/limit
        #note: the where query is currently limited to only single hash conditions
        def source.destructive_transaction? (value = self)
            value !~ /(?:\A[a-z]+)(?:(\.)?(?(1)(?:(?:limit|order|where)\(\w*:?\s?:?'?[\w\s-]*'?\))))*$/i
        end
    end

    extend self
end
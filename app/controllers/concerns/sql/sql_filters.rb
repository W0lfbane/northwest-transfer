module Concerns::SQL::SqlFilters
    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        define_class_methods(source)
    end

    def define_class_methods(source = self)
        # Returns false if input string does not follow pattern of: Modelname or Modelname.find/where/order/limit
        def safe_transaction? (value, blacklisted_words = ['destroy', 'delete', 'update', 'create', 'save', '!'])
            # Check to make sure the evaluated code is DB related, and not some other arbitrary execution
            model_include?(value) &&
            !blacklisted_words.any? { |word| value.include?(word) }
            
            # Insert fail-proof regex here
        end
        
        def model_include?(model)
            # Eager load all models
            Rails.application.eager_load! # Likely to be subbed for a better solution later
            model_list = ApplicationRecord.descendants.map(&:name)
            model_list.any? { |model_name| model.include?(model_name) }
        end
    end

    extend self
end
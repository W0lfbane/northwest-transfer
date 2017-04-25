module Concerns::String::SqlFilters

    private
    
        def safe_transaction? (value = self, blacklisted_words = ['destroy', 'delete', 'update', 'create', 'save', '!'])
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

    extend self
    
    
end
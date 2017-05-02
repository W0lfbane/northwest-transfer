module Concerns::Tasks::Taskable
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        source.class_eval do
            has_many :tasks, as: :taskable, dependent: :destroy
            accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true
        end
    end

    extend self
end